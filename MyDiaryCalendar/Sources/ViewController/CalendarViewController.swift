//
//  CalendarViewController.swift
//  MyDiaryCalendar
//
//  Created by KEEN on 2021/11/01.
//

import UIKit
import FSCalendar
import RealmSwift

class CalendarViewController: UIViewController {

  // MARK: - Properteis
  let localRealm = try! Realm()
  var tasks: Results<UserDiary>!
  
  // MARK: - UI
  @IBOutlet weak var calendarView: FSCalendar!
  @IBOutlet weak var allCountLabel: UILabel!
  
  // MARK: - View Life-Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "달력"
    calendarView.delegate = self
    calendarView.dataSource = self
    
    tasks = localRealm.objects(UserDiary.self)
    
    let allCount = getAllDiaryCountFromUserDiary()
    allCountLabel.text = "총 \(allCount)개의 일기가 있습니다."
    
    // filter & sort 하기
    /*
    let recent = tasks.sorted(byKeyPath: "writtenDate", ascending: false).first
    let old = tasks.sorted(byKeyPath: "writtenDate", ascending: true).first
    
    let full = tasks.filter("content != nil").count
    let favorite = tasks.filter("favorite == false").count
    let search = tasks.filter("diaryTitle CONTAINTS[c] '일기'") // 원하는 일기 가져오기
     */
  }

}

// MARK: - Extension
// MARK: - FSCalendarDelegate
extension CalendarViewController: FSCalendarDelegate {
  
}

// MARK: - FSCalendarDataSource
extension CalendarViewController: FSCalendarDataSource {
  // Date: 시분초까지 모두 동일하게
  // 1. 영국 표준시 기준으로 표기
  // 2. date formatter
  func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
    // 날짜마다 일기의 갯수를 리턴
    return tasks.filter("writtenDate == %@", date).count
  }
  
  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    // 날짜에 해당하는 일기 목록을 보여주기
  }
}
