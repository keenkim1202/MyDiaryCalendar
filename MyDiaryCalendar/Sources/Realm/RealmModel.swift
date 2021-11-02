//
//  RealmModel.swift
//  MyDiaryCalendar
//
//  Created by KEEN on 2021/11/02.
//

import Foundation
import RealmSwift

// UserDiary: 테이블 이름
// @Persisted: 컬럼
class UserDiary: Object {
  @Persisted var diaryTitle: String // 제목 (필수)
  @Persisted var content: String? // 내용 (옵션)
  @Persisted var writtenDate: Date // 작성 날짜 (필수)
  @Persisted var regDate: Date // 등록일 (필수)
  
  // PK (필수) : AuthoIncrement
  /// 가능한 타입 - Int, String, UUID, ObjectID -> AutoIncrement
  @Persisted(primaryKey: true) var _id: ObjectId
  
  convenience init(diaryTitle: String, content: String?, writtenDate: Date, regDate: Date) {
    self.init()
    
    self.diaryTitle = diaryTitle
    self.content = content
    self.writtenDate = writtenDate
    self.regDate = regDate
  }
}
