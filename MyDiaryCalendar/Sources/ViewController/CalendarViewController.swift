//
//  CalendarViewController.swift
//  MyDiaryCalendar
//
//  Created by KEEN on 2021/11/01.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController {

  // MARK: - UI
  @IBOutlet weak var calendarView: FSCalendar!
  
  // MARK: - View Life-Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    calendarView.delegate = self
    calendarView.dataSource = self
    
    title = "달력"
  }

}

// MARK: - Extension
// MARK: - FSCalendarDelegate
extension CalendarViewController: FSCalendarDelegate {
  
}

// MARK: - FSCalendarDataSource
extension CalendarViewController: FSCalendarDataSource {
  func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
    return "title"
  }
  
  func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
    return "subTitle"
  }
  
  func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
    return UIImage(systemName: "star")
  }
  
  func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
    return 2
  }
}
