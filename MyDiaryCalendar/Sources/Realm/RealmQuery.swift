//
//  RealmQuery.swift
//  MyDiaryCalendar
//
//  Created by KEEN on 2021/11/05.
//

import UIKit
import RealmSwift

// TODO: Realm 과 과련된 부분 분리해서 extension에 작성하기

extension UIViewController {
  // MARK: - Method
  func searchQuryFromUserDiary(q: String) -> Results<UserDiary> {  // 원하는 일기 가져오기
    let localRealm = try! Realm()
    let search = localRealm.objects(UserDiary.self).filter("diaryTitle CONTAINTS[c] '\(q)' OR content CONTAINTS[c] '\(q)'")
    
    return search
  }
  
  func getAllDiaryCountFromUserDiary() -> Int {
    let localRealm = try! Realm()
    return localRealm.objects(UserDiary.self).count
  }
}
