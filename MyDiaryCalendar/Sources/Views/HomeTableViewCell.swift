//
//  HomeTableViewCell.swift
//  MyDiaryCalendar
//
//  Created by KEEN on 2021/11/08.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
  
  static let identifier: String = "homeTableViewCell"
  
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var collectionView: UICollectionView!
  
  override class func awakeFromNib() {
    super.awakeFromNib()
    
//    collectionView.delegate = self
//    collectionView.dataSource = self
  }
}
