//
//  AddViewController.swift
//  MyDiaryCalendar
//
//  Created by KEEN on 2021/11/01.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController {
  
  let localRealm = try! Realm()
  
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var datePicker: UIButton!
  @IBOutlet weak var contentTextField: UITextView!
  
  // MARK: View Life-Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "일기 작성"
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(onDone))
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(onSave))
  }
  
  @objc func onDone() {
    self.dismiss(animated: true, completion: nil)
  }
  
  @objc func onSave() {
    let task = UserDiary(diaryTitle: titleTextField.text!, content: contentTextField.text!, writtenDate: Date(), regDate: Date()) // write할 task 생성
    try! localRealm.write { // realm에 써라. (CRUD)
      localRealm.add(task) // 그 중 Add를 해줘라.
    }
    
    self.dismiss(animated: true, completion: nil)
  }
}
