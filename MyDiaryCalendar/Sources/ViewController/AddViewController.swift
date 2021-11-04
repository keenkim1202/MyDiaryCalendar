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
    case update
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
      viewType = .update
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
    
    if viewType == .update {
      try! localRealm.write {
        localRealm.create(
          UserDiary.self,
          value: ["_id": diary!._id,
                  "diaryTitle": task.diaryTitle,
                  "content": task.content ?? "내용없음",
                  "writtenDate": Date(),
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
}
