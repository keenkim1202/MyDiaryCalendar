//
//  SettingViewController.swift
//  MyDiaryCalendar
//
//  Created by KEEN on 2021/11/01.
//

/*
 백업하기
 
 [ 사용자의 아이폰 저장 공간 확인 ]
 - 부족: 백업 불가
 [ 백업 진행 ]
 - 어떤 데이터도 없는 경우라면 백업할 데이터가 없다고 안내
 - 백업 가능한 파일 여부 확인
 - 1) realm(realm에 대한 데이터가 1개라도 있는지)
 - 2) folder(백업할 파일이 있는지)
 - progress + UI interaction 금지
 [ zip ]
 - 벡업 완료 시점에
 - progress + UI interacton 허용
 - 공유화면
 */

import UIKit
import Zip

class SettingViewController: UIViewController {
  
  // MARK: - View Life-Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "설정"
  }
  
  // 1. 도큐먼트 폴터 위치
  func documnetDirectoryPath() -> String? {
    let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
    let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
    let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true) // 첫번째 요소가 url 정보를 가지고 있다.
    
    if let directoryPath = path.first {
      return directoryPath
    } else {
      return nil
    }
  }
  
  // MARK: - Present Activity VC
  func presentActivityVC() {
    let vc = UIActivityViewController(activityItems: ["이것은 액티비티 뷰컨입니다."], applicationActivities: nil)
    self.present(vc, animated: true, completion: nil)
  }
  
  // MARK: - Action
  @IBAction func onActivityVC(_ sender: UIButton) {
    presentActivityVC()
  }
  
  @IBAction func onBackUp(_ sender: UIButton) {
    // 4. 백업한 파일에 대한 URL 배열
    var urlPaths = [URL]()
    
    // 1. 도큐먼트 폴더 위치
    if let path = documnetDirectoryPath() {
      // 2-1. 백업하고자 하는 파일 확인
      /// : 이미지의 경우, 백업 편의성을 위해 폴더를 생성하고, 폴더 안에 이미지를 저장하는 것이 효율적이다.
      let realm  = (path as NSString).appendingPathComponent("default.realm") // realm 폴더에 대한 위치
      // 2-2. 백업하고자 하는 파일 존재 여부 확인 (위에서는 파일이 존재하는 경로의 존재 여부만 확인한다.)
      if FileManager.default.fileExists(atPath: realm) {
        urlPaths.append(URL(string: realm)!) // realm이라는 문자열이 존재한다는 것을 위에서 확인했기에 !를 써도 된다.
      } else {
        // TODO: 사용자에게 alert문을 띄우는 식으로 수정
        print("백업할 파일이 없습니다.")
      }
    }
    
    // 3. 백업
    /// : 4번 배열에 대해 압축 파일 만들기
    do {
      let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: "archive") // Zip
      print("압축 경로: \(zipFilePath)")
    }
    catch {
      print("Something went wrong")
    }
  }
  
}
