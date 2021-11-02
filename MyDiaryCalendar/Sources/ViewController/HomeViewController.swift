//
//  HomeViewController.swift
//  MyDiaryCalendar
//
//  Created by KEEN on 2021/11/01.
//

import UIKit

class HomeViewController: UIViewController {
  
  // MARK: View Life-Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "HOME"
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(presentAddVC))
  }
  
  @objc func presentAddVC() {
    let storyboard = UIStoryboard.init(name: "Content", bundle: nil)
    guard let vc = storyboard.instantiateViewController(identifier: "addVC") as? AddViewController else { return }
    
    let nav = UINavigationController(rootViewController: vc)
    nav.modalPresentationStyle = .fullScreen
    self.present(vc, animated: true, completion: nil)
  }
  
}
