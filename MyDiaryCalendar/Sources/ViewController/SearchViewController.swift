//
//  SearchViewController.swift
//  MyDiaryCalendar
//
//  Created by KEEN on 2021/11/01.
//

import UIKit
import RealmSwift

// TODO: SearchBar 추가해보기

class SearchViewController: UIViewController {
  
  // MARK: Realm
  let localRealm = try! Realm()
  var tasks: Results<UserDiary>!
  let formatter:  DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "yyyy년 MM월 dd일"
    return df
  }()

  // MARK: UI
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: View Life-Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "검색"
    tableView.delegate = self
    tableView.dataSource = self
    
    tasks = localRealm.objects(UserDiary.self).sorted(byKeyPath: "diaryTitle", ascending: false)
    print("Realm Location: ", localRealm.configuration.fileURL ?? "cannot find locaation.")
//    print("tasks: \(tasks)")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
    tasks = localRealm.objects(UserDiary.self)
    tableView.reloadData()
  }
  
  // MARK: Load Ducument
  func loadImageFromDocumentDirectory(imageName: String) -> UIImage? {
    let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
    let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
    let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
    
    if let directoryPath = path.first {
      let imageURL = URL(fileURLWithPath: directoryPath).appendingPathComponent(imageName)
      return UIImage(contentsOfFile: imageURL.path)
    }
    return nil
  }
  
  // MARK: Remove Document
  func deleteImageFromDucumnetDirectory(imageName: String) {
    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
    let imageURL = documentDirectory.appendingPathComponent(imageName)

    if FileManager.default.fileExists(atPath: imageURL.path) {
      do {
        try FileManager.default.removeItem(at: imageURL)
        print("REMOVE SUCCESS")
      } catch {
        print("REMOVE FAILED")
      }
    }
  }
}

// MARK: Extension - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 120
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let contentStoryboard = UIStoryboard.init(name: "Content", bundle: nil)
    let vc = contentStoryboard.instantiateViewController(withIdentifier: "addVC") as! AddViewController
  
    let selectedDiary = tasks[indexPath.row]
    vc.diary = selectedDiary

    let nav = UINavigationController(rootViewController: vc)
    nav.modalPresentationStyle = .fullScreen
    self.present(nav, animated: true, completion: nil)
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
    let date = formatter.string(from: row.writtenDate)
    cell.dirayImageView.image = loadImageFromDocumentDirectory(imageName: "\(row._id).jpg")
    cell.titleLabel.text = row.diaryTitle
    cell.dateLabel.text = "\(date)"
    cell.contentLabel.text = row.content
    
    cell.cellConfigure()
    return  cell
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    let row = tasks[indexPath.row]
    
    try! localRealm.write {
      deleteImageFromDucumnetDirectory(imageName: "\(row._id).jpg")
      localRealm.delete(row)
      tableView.reloadData()
    }
  }
}
