//
//  KakaoAPIManager.swift
//  Week6
//
//  Created by SC on 2022/08/08.
//

import Foundation

import Alamofire
import SwiftyJSON


class KakaoAPIManager {
    static let shared = KakaoAPIManager()
    
    private init() { }
    
    let headers: HTTPHeaders = ["Authorization": "KakaoAK \(APIKey.kakao)"]
    
    // Alamofire에서는 -> URLSession Framework가 내부적으로 동작 -> 비동기로 Request
    // 이미 구현이 되어 있기 때문에 DispatchQueue 처리를 할 필요 X
    
    // Alamofire + SwiftyJSON을 통해서 네트워크 통신
    // 검색 키워드가 들어간다
    // 인증키도 들어간다
    func callRequest(type: Endpoint, query: String, completionHandler: @escaping (JSON) -> ()) {
        print(#function, "START")
        
//        let platform = Endpoint.blog
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Cannot encode input text")
            return
        }
        let url = "\(type.requestURL)\(query)"
        
        // AF에서 핸들러를 자동으로 메인 스레드로 바꿔 준다
        AF.request(url, method: .get, headers: headers).validate().responseData { response in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
//                    print("JSON: \(json)")
                    
                    completionHandler(json)  // 클로저 구문 안에 클로저를 작성했기 때문에 @escaping 처리 (바깥에서 실행하니까)
                    
//                    self.tableView.reloadData()  // 여기에서 reload한다면?? -> 블로그에 대한 값만 뜨게 될 것
                case .failure(let error):
                    print(error)
            }
        }
        print(#function, "END")
    }
}
