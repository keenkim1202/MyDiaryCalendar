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
    
    title = "홈"
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(presentAddVC))
  }
  
  @objc func presentAddVC() {
    let contentStoryboard = UIStoryboard.init(name: "Content", bundle: nil)
    let vc = contentStoryboard.instantiateViewController(withIdentifier: "addVC") as! AddViewController
    
    let nav = UINavigationController(rootViewController: vc)
    nav.modalPresentationStyle = .fullScreen
    self.present(nav, animated: true, completion: nil)
  }
  
}
