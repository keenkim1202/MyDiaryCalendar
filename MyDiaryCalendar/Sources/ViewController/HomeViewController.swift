//
//  HomeViewController.swift
//  MyDiaryCalendar
//
//  Created by KEEN on 2021/11/01.
//

import UIKit

class HomeViewController: UIViewController {
  
  // MARK: - Properties
  let array = [ // dummy data
    "안녕하세요".map{ String($0) },
    Array(repeating: "b", count: 10),
    Array(repeating: "c", count: 10),
    Array(repeating: "d", count: 10),
    Array(repeating: "e", count: 10)
  ]
  
  // MARK: - UI
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: - View Life-Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
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

// MARK: - Extension
// MARK: - UITableViewDelegate & UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return array.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier) as? HomeTableViewCell else { return UITableViewCell() }
    cell.collectionView.tag = indexPath.row
    cell.collectionView.isPagingEnabled = true
    cell.collectionView.reloadData()
    
    cell.data = array[indexPath.row]
    cell.categoryLabel.text = "\(array[indexPath.row])"
    
    cell.categoryLabel.backgroundColor = .black
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return indexPath.row == 1 ? 300 : 170
  }
  
}
