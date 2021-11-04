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

/*
 복구하기
 - 사용자의 아이폰 저장 공간 확인
 - 파일 앱
  - zip : zip 선택 > unzip하기 > 백업 파일 이름 확인 (폴더, 파일 이름 확인)
  - 파일 이름 확인 결과, 정상적인 파일이 아니면 alert문 띠우기
 - 백업 데이터 선택
 - 백업 파일 확인
 - 백업 당시 데이터랑 지금 현재 앱에서 사용중인 데이터를 어떻게 합칠 것인가
 */

import UIKit
import Zip
import MobileCoreServices
import UniformTypeIdentifiers

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
    // 압축 파일 경로 가져오기
    /// : 지금은 고정된 파일 이름이므로 archive.zip을 문자열로 작성했지만, 상황에 따라 유동적으로 대입해주면 된다.
    let fileName = (documnetDirectoryPath()! as NSString).appendingPathComponent("archive.zip")
    let fileURL = URL(fileURLWithPath: fileName)
    
    
    let vc = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
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
      presentActivityVC()
    }
    catch {
      print("Something went wrong")
    }
  }
  
  @IBAction func onRestore(_ sender: UIButton) {
    // 복구1. 파일앱 열기 + 확장자 : MobileCoreServices 임포트 하기
    
//    let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeArchive as String], in: .import)
    let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.archive], asCopy: true)
    
    documentPicker.delegate = self
//    documentPicker.allowsMultipleSelection // 파일 여러개 선택하기 <- 파일 복구의 입장에서는 필요 없지만 알아두자.
    self.present(documentPicker, animated: true, completion: nil)
  }
}

// MARK: - Extension - UIDocumentPickerDelegate
extension SettingViewController: UIDocumentPickerDelegate {
  func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    print(#function)
  }
  
  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    print(#function)
    
    // 복구2. 선택한 파일에 대한 경로를 가져와야 한다
    // ex. iphone/keen/fileapp/archive.zip
    // ~~~~~/document/ <- 여기 뒤에 archive.zip을 붙여준다.
    guard let selectedFileURL = urls.first else { return }
    
    let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! // 도큐먼트 위치
    
    let sandboxFileURL = directory.appendingPathComponent(selectedFileURL.lastPathComponent) // 도큐먼트 위치에 file의 마지막요소 (즉, 파일이름)을 붙여주겠다
    
    // 복구3. 압축해제
    if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
      // 기존에 복구하고자 하는 zip 파일이 도큐먼트에 있다면 -> 바로 압축을 해제해줘라
      do {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentDirectory.appendingPathComponent("archive.zip") // 도큐먼트 위치에 파일 이름 추가
        
        try Zip.unzipFile(
          fileURL,
          destination: documentDirectory,
          overwrite: true,
          password: nil,
          progress: { progress in
            print("progress: \(progress)")
            // 복구가 완료되었다는 alert or 앱을 재시작해달라는 alert
          }, fileOutputHandler: { unzippedFile in
            print("unzippedFile: \(unzippedFile)")
          }
        )
      } catch {
        print("unzip failed.")
      }
    } else {
      // 이 경로에 파일이 없다면 -> 여기로 파일을 옮겨줘라
      // 파일 앱의 zip -> 도큐먼트 폴더에 복사
      do {
        try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
        
        // TODO: 여기서 부터는 if문과 동일
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentDirectory.appendingPathComponent("archive.zip") // 도큐먼트 위치에 파일 이름 추가
        
        try Zip.unzipFile(
          fileURL,
          destination: documentDirectory,
          overwrite: true,
          password: nil,
          progress: { progress in
            print("progress: \(progress)")
            // 복구가 완료되었다는 alert or 앱을 재시작해달라는 alert
          }, fileOutputHandler: { unzippedFile in
            print("unzippedFile: \(unzippedFile)")
          }
        )
      } catch {
        print("error")
      }
    }
  }
}
