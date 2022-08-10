//
//  ViewController.swift
//  Week6
//
//  Created by SC on 2022/08/08.
//

import UIKit

//import Alamofire
import SwiftyJSON

/*
 1. html tag <> </> 기능 활용 (애플에 있음)
 2. 문자열 대체 메서드
 */

/*
 TableView Automatic Dimension
 - 컨텐츠 양에 따라서 셀 높이가 자유롭게 지정
 - 조건 1: 레이블 numberOfLines 0
 - 조건 2: tableView row Height automaticDimension
 - 조건 3: 레이아웃
 */


class BlogSearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var blogList: [String] = []
    var cafeList: [String] = []
    
    var isExpanded = false  // false 2줄, true 0으로!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(#function, "START")
//        requestBlog(query: "아이스크림")  // 블로그 먼저 요청하고, 응답 오면 카페 API 요청하기
//        KakaoAPIManager.shared.callRequest(type: .blog, query: "아이스크림")
        
        searchBlog()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension  // 모든 섹션과 모든 셀에 대해서 다 유동적으로 높이를 잡겠다!
    }
    
    
    func searchBlog() {
        KakaoAPIManager.shared.callRequest(type: .blog, query: "고래밥") { json in
//            print(json)
            
            for item in json["documents"].arrayValue {
                let value = item["contents"].stringValue.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
                self.blogList.append(value)
            }
            
//            self.blogList = json["documents"].arrayValue.map { $0["contents"].stringValue }  // ➕  // filter는 result 타입이 Bool
            
            // 이 자리에서 테이블 뷰를 갱신하거나, 다시 한 번 더 APIManager 호출해 볼 수 있을 것
            self.searchCafe()
        }
        print(#function, "END")
    }
    
    
    func searchCafe() {
        KakaoAPIManager.shared.callRequest(type: .cafe, query: "고래밥") { json in
            for item in json["documents"].arrayValue {
                self.cafeList.append(item["contents"].stringValue)
            }
            print(self.blogList)
            print(self.cafeList)
            
            self.tableView.reloadData()
        }
    }
    
    
    @IBAction func expandCell(_ sender: UIBarButtonItem) {
        isExpanded = !isExpanded
//        isExpanded.toggle()
        tableView.reloadData()
    }
    //    func requestCafe(query: String) {
//        print(#function, "START")
//        let headers: HTTPHeaders = ["Authorization": "KakaoAK \(APIKey.kakao)"]
//
//        let platform = Endpoint.cafe
//        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
//            print("Cannot encode input text")
//            return
//        }
//        let url = "\(platform.requestURL)\(query)"
//
//        // AF에서 핸들러를 자동으로 메인 스레드로 바꿔 준다
//        AF.request(url, method: .get, headers: headers).validate().responseData { response in
//            switch response.result {
//                case .success(let value):
//                    let json = JSON(value)
//                    print("JSON: \(json)")
//
////                    self.requestCafe()  // 무한반복되기 때문에 앱이 어느 순간 꺼지게 될 것
//
////                    self.tableView.reloadData()  // 여기에서 reload한다면?? -> 블로그에 대한 값만 뜨게 될 것
//                case .failure(let error):
//                    print(error)
//            }
//        }
//        print(#function, "END")
//    }
}

extension BlogSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "블로그 검색결과" : "카페 검색결과"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return blogList.count
//        } else {
//            return cafeList.count
//        }
        
        return section == 0 ? blogList.count : cafeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "KakaoCell", for: indexPath) as? KakaoCell else {
            print("Cannot find KakaoCell")
            return UITableViewCell()
        }
        
        cell.testLabel.numberOfLines = isExpanded ? 0 : 2
        cell.testLabel.text = indexPath.section == 0 ? blogList[indexPath.row] : cafeList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? UITableView.automaticDimension : 60
    }
}


class KakaoCell: UITableViewCell {
    @IBOutlet weak var testLabel: UILabel!  // 아웃렛 연결이 잘 안 되면 코드 먼저 적고 연결
}
