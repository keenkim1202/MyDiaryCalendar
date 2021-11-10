//
//  HomeTableViewCell.swift
//  MyDiaryCalendar
//
//  Created by KEEN on 2021/11/08.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
  
  static let identifier: String = "homeTableViewCell"
  
  var data: [String] = [] {
    didSet {
      categoryLabel.text = "\(data.count)개"
      collectionView.reloadData()
    }
  }
  
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var collectionView: UICollectionView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.isPagingEnabled = true
  }

}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension HomeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print(collectionView.tag)
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return data.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
    if collectionView.tag == 0 {
      cell.imageView.backgroundColor = .brown
    } else {
      cell.imageView.backgroundColor = .magenta
    }
    cell.contentLabel.text = data[indexPath.item]
    
    return cell
  }
}

// MARK: - UICollectionViewFlowLayout
extension HomeTableViewCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    // tableView cell의 indexPath 정보 가져오기
    if collectionView.tag == 0 {
      return CGSize(width: UIScreen.main.bounds.width, height: 100)
    } else {
      return CGSize(width: 150, height: 100)
    }
    
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    if collectionView.tag == 0 {
      return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    } else {
      return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return collectionView.tag == 0 ? 0 : 10
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return collectionView.tag == 0 ? 0 : 10
  }
}
