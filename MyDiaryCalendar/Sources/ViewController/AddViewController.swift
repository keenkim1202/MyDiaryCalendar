//
//  AddViewController.swift
//  MyDiaryCalendar
//
//  Created by KEEN on 2021/11/01.
//

import UIKit
import RealmSwift

// TODO: Realm / Document 에 이미지 정보 저장하는 코드 작성하기

class AddViewController: UIViewController {
  
  // MARK: Enum
  enum ViewType {
    case add
    case update
  }
  
  // MARK: Properties
  let localRealm = try! Realm()
  let imagePicker = UIImagePickerController()
  var viewType: ViewType = .add
  var diary: UserDiary?
  
  let formatter:  DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "yyyy년 MM월 dd일"
    return df
  }()
  
  
  //MARK: UI
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var datePickerButton: UIButton!
  @IBOutlet weak var contentTextField: UITextView!
  @IBOutlet weak var contentImageView: UIImageView!
  
  // MARK: View Life-Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    imagePicker.delegate = self
    configureNAV()
  }
  
  func configureNAV() {
    let cancelBarButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(onDone))
    let saveBarButton = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(onSave))
    let imageAddBarButton = UIBarButtonItem(title: "이미지 추가", style: .done, target: self, action: #selector(onAddImage))
    
    cancelBarButton.tintColor = .red
    saveBarButton.tintColor = .systemGreen
    
    navigationItem.leftBarButtonItem = cancelBarButton
    navigationItem.rightBarButtonItems = [saveBarButton, imageAddBarButton]
    
    if let diary = diary {
      viewType = .update
      title = "일기 수정"
      titleTextField.text = diary.diaryTitle
      contentTextField.text = diary.content
      imageAddBarButton.title = "이미지 변경"
    } else {
      title = "일기 작성"
    }
  }
  
  // MARK: Photo Library & Camera Access
  func openLibrary() {
    imagePicker.sourceType = .photoLibrary
    present(imagePicker, animated: false, completion: nil)
  }
  
  func openCamera() {
    if(UIImagePickerController .isSourceTypeAvailable(.camera)) {
      imagePicker.sourceType = .camera
      present(imagePicker, animated: false, completion: nil)
    }
    else{
      print("Camera not available")
    }
  }
  
  // MARK: - BarButtonItem - Actions
  @objc func onDone() {
    self.dismiss(animated: true, completion: nil)
  }
  
  @objc func onAddImage() {
    let alert =  UIAlertController(title: "일기 이미지 추가", message: "어디에서 이미지를 불러오시겠습니까?", preferredStyle: .actionSheet)
    let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in
      self.openLibrary()
    }
    
    let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
      self.openCamera()
    }
    
    let defaultImage =  UIAlertAction(title: "기본 이미지로 변경", style: .default) { (action) in
      self.contentImageView.image = UIImage(systemName: "folder")
    }
    
    let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    
    alert.addAction(library)
    alert.addAction(camera)
    alert.addAction(defaultImage)
    alert.addAction(cancel)
    present(alert, animated: true, completion: nil)
  }
  
  @objc func onSave() {
    guard let date = datePickerButton.currentTitle, let value = formatter.date(from: date) else { return }
    print("saveButton value = \(value)")
    let task = UserDiary(
      diaryTitle: titleTextField.text!, content: contentTextField.text!,
      writtenDate: value, regDate: Date()
    )
    
    if viewType == .update {
      try! localRealm.write {
        localRealm.create(
          UserDiary.self,
          value: ["_id": diary!._id,
                  "diaryTitle": task.diaryTitle,
                  "content": task.content ?? "내용없음",
                  "writtenDate": value,
                  "regDate": Date()],
          update: .modified
        )
      }
    } else {
      try! localRealm.write {
        localRealm.add(task)
        saveImageToDocumentDirectory(imageName: "\(task._id).jpg", image: contentImageView.image!)
      }
    }
    self.dismiss(animated: true, completion: nil)
  }
  
  // MARK: Save Document
  func saveImageToDocumentDirectory(imageName: String, image: UIImage) {
    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
    let imageURL = documentDirectory.appendingPathComponent(imageName)
    guard let data = image.jpegData(compressionQuality: 0.2) else { return }

    if FileManager.default.fileExists(atPath: imageURL.path) {
    /// 기존 경로에 있는 이미지 삭제
      do {
        try FileManager.default.removeItem(at: imageURL)
        print("REMOVE SUCCESS")
      } catch {
        print("REMOVE FAILED")
      }
    }
    /// 이미지를 도큐먼트에 저장
    do {
      try data.write(to: imageURL)
    } catch {
      print("WRITE FAILED")
    }
  }
  
  // MARK: - Actions
  @IBAction func onDatePickerButton(_ sender: UIButton) {
    // alert custom
    guard let contentView = self.storyboard?.instantiateViewController(withIdentifier: "datePickerVC") as? DatePickerViewController else { return }
    contentView.preferredContentSize.height = 200
    
    let alert = UIAlertController(title: "날짜 선택", message: "날짜를 선택해주세요", preferredStyle: .alert)
    alert.setValue(contentView, forKey: "contentViewController")
    
    let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    let ok = UIAlertAction(title: "확인", style: .default) { _ in
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy년 MM월 dd일"
      let value = formatter.string(from: contentView.datePicker.date)
      
      // 확인 버튼을 눌렀을 떄 버튼의 타이틀 변경
      print("datePicker Button value: \(value)")
      self.datePickerButton.setTitle("\(value)", for: .normal)
    }
    
    alert.addAction(cancel)
    alert.addAction(ok)
    self.present(alert, animated: true, completion: nil)
  }
}

// MARK: - Extension - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension AddViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      contentImageView.image = image
      print(info)
    }
    
    dismiss(animated: true, completion: nil)
  }
}
