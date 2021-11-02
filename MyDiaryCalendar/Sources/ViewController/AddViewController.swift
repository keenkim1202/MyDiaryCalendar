//
//  AddViewController.swift
//  MyDiaryCalendar
//
//  Created by KEEN on 2021/11/01.
//

import UIKit

class AddViewController: UIViewController {
  
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
    self.dismiss(animated: true, completion: nil)
  }
}
