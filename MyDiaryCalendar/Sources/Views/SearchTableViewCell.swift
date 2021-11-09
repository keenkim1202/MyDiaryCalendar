//
//  SearchTableViewCell.swift
//  MyDiaryCalendar
//
//  Created by KEEN on 2021/11/02.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
  
  static let identifier = "searchCell"
  
  @IBOutlet weak var dirayImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var contentLabel: UILabel!
  
  func cellConfigure(row: UserDiary) {
    dirayImageView.layer.cornerRadius = CGFloat(8)
    dirayImageView.backgroundColor = .blue
    
    let date = DateFormatter.customFormat.string(from: row.writtenDate)

    titleLabel.text = row.diaryTitle
    dateLabel.text = "\(date)"
    contentLabel.text = row.content
  }
}
