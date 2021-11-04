//
//  AddViewController.swift
//  MyDiaryCalendar
//
//  Created by KEEN on 2021/11/01.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController {
  
  // MARK: Enum
  enum ViewType {
    case add
    case udpate
  }
  
  // MARK: Properties
  let localRealm = try! Realm()
  var viewType: ViewType = .add
  var diary: UserDiary?
  
  //MARK: UI
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var datePicker: UIButton!
  @IBOutlet weak var contentTextField: UITextView!
  @IBOutlet weak var contentImageView: UIImageView!
  
  // MARK: View Life-Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let diary = diary {
      title = "일기 수정"
      titleTextField.text = diary.diaryTitle
      contentTextField.text = diary.content
    } else {
      title = "일기 작성"
    }
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(onDone))
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(onSave))
  }
  
  @objc func onDone() {
    self.dismiss(animated: true, completion: nil)
  }
  
  @objc func onSave() {
    let task = UserDiary(
      diaryTitle: titleTextField.text!, content: contentTextField.text!,
      writtenDate: Date(), regDate: Date()
    )
    
    try! localRealm.write {
      localRealm.add(task)
      saveImageToDocumentDirectory(imageName: "\(task._id).jpg", image: contentImageView.image!)
    }
    self.dismiss(animated: true, completion: nil)
  }
  
  func saveImageToDocumentDirectory(imageName: String, image: UIImage) {
    // 1. 이미지 저장할 경로 설정: 도큐먼트 폴더, FileManager
    /// ex. Desktop/keen/ios/folder
    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
    
    // 2. 이미지 파일 이름 & 최종 경로 설정
    /// ex. Desktop/keen/ios/folder/222.jpg
    let imageURL = documentDirectory.appendingPathComponent(imageName)
    
    // 3. 이미지 압축
//    guard let data = image.pngData() else { return }
    guard let data = image.jpegData(compressionQuality: 0.2) else { return }
    
    // 4. 이미지 저장: 동일한 경로에 이미지를 저장하게 될 경우, 덮어쓰기
    /// 4-1. 이미지 경로 여부 확인
    if FileManager.default.fileExists(atPath: imageURL.path) {
      // 4-2. 기존 경로에 있는 이미지 삭제
      do {
        try FileManager.default.removeItem(at: imageURL)
        print("REMOVE SUCCESS")
      } catch {
        print("REMOVE FAILED")
      }
    }
    
    // 5. 이미지를 도큐먼트에 저장
    do {
      try data.write(to: imageURL)
    } catch {
      print("WRITE FAILED")
    }
  }
}
