//
//  AddViewController.swift
//  MyDiaryCalendar
//
//  Created by KEEN on 2021/11/01.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController {
  
  // MARK: Properties
  let localRealm = try! Realm()
  
  //MARK: UI
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
    let task = UserDiary(diaryTitle: titleTextField.text!, content: contentTextField.text!, writtenDate: Date(), regDate: Date())
    try! localRealm.write {
      localRealm.add(task)
    }
    
    self.dismiss(animated: true, completion: nil)
  }
}
