//
//  SearchViewController.swift
//  MyDiaryCalendar
//
//  Created by KEEN on 2021/11/01.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController {
  
  // MARK: Realm
  let localRealm = try! Realm()
  var tasks: Results<UserDiary>! // 아무것도 없으면 ! 해도 0개로 리턴됨

  // MARK: UI
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: View Life-Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "검색"
    tableView.delegate = self
    tableView.dataSource = self
    
    tasks = localRealm.objects(UserDiary.self)
    print("tasks: \(tasks)")
  }
  
}

// MARK: Extension - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 120
  }
}

// MARK: Extension - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tasks.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier) as? SearchTableViewCell else { return UITableViewCell() }
    let row = tasks[indexPath.row]
    cell.titleLabel.text = row.diaryTitle
    cell.dateLabel.text = "\(row.writtenDate)"
    cell.contentLabel.text = row.content
    
    cell.cellConfigure()
    return  cell
  }
}
