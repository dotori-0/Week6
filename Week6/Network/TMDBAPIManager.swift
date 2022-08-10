//
//  TMDBAPIManager.swift
//  Week6
//
//  Created by SC on 2022/08/10.
//

import Foundation

import Alamofire
import SwiftyJSON


class TMDBAPIManager {
    static let shared = TMDBAPIManager()
    
    private init() { }
    
    let tvList = [
        ("환혼", 135157),
        ("이상한 변호사 우영우", 197067),
        ("인사이더", 135655),
        ("미스터 션사인", 75820),
        ("스카이 캐슬", 84327),
        ("사랑의 불시착", 94796),
        ("이태원 클라스", 96162),
        ("호텔 델루나", 90447)
    ]
    
    let imageURL = "https://image.tmdb.org/t/p/w500"
    
    func callRequest(query: Int, completionHandler: @escaping ([String]) -> ()) {
        print(#function, "START")
        
        let seasonURL = "https://api.themoviedb.org/3/tv/\(query)/season/1?api_key=\(APIKey.tmdb)&language=ko-KR"
        
        // AF에서 핸들러를 자동으로 메인 스레드로 바꿔 준다
        AF.request(seasonURL, method: .get).validate().responseData { response in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    
                    // json still_path > [String]
                    // for-loop
                    var stillArray: [String] = []
                    for list in json["episodes"].arrayValue {
                        let value = list["still_path"].stringValue
                        stillArray.append(value)
                    }
                    dump(stillArray)  // print vs dump
                    dump(self.tvList)
                    
                    // map
                    let stillPaths = json["episodes"].arrayValue.map { $0["still_path"].stringValue }
                    print(type(of: stillPaths))
//                    print(stillPaths)
                    
                    completionHandler(stillPaths)  // 클로저 구문 안에 클로저를 작성했기 때문에 @escaping 처리 (바깥에서 실행하니까)
                    
                case .failure(let error):
                    print(error)
            }
        }
        print(#function, "END")
    }
    
    
    func requestImage(completionHandler: @escaping ([[String]]) -> ()) {
        
        var posterList: [[String]] = []
        
        // 나~~~~~중에 배울 것: async/await(iOS 13 이상)
        TMDBAPIManager.shared.callRequest(query: tvList[0].1) { value in
            posterList.append(value)

            TMDBAPIManager.shared.callRequest(query: self.tvList[1].1) { value in
                posterList.append(value)

                TMDBAPIManager.shared.callRequest(query: self.tvList[2].1) { value in
                    posterList.append(value)
                   
                    TMDBAPIManager.shared.callRequest(query: self.tvList[3].1) { value in
                        posterList.append(value)
                     
                        TMDBAPIManager.shared.callRequest(query: self.tvList[4].1) { value in
                            posterList.append(value)
                           
                            TMDBAPIManager.shared.callRequest(query: self.tvList[5].1) { value in
                                posterList.append(value)
                                
                                TMDBAPIManager.shared.callRequest(query: self.tvList[6].1) { value in
                                    posterList.append(value)
                                    
                                    TMDBAPIManager.shared.callRequest(query: self.tvList[7].1) { value in
                                        posterList.append(value)
                                        completionHandler(posterList)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func requestEpisodeImage() {
        
        // tvList for-loop 문제점들
        // 1. 순서 보장 X
        // 2. 언제 끝날지 모름
        // 3. 네트워크 통신 Limit (ex. 1초에 5번 통신 요청 오면 block)
//        for item in tvList {
//            TMDBAPIManager.shared.callRequest(query: item.1) { stillPaths in
//                print(stillPaths)
//            }
//        }
        
        
        let id = tvList[7].1  // 90447
        
        TMDBAPIManager.shared.callRequest(query: id) { stillPaths in
            print(stillPaths)
            
            TMDBAPIManager.shared.callRequest(query: self.tvList[5].1) { stillPaths in
                print(stillPaths)
            }
        }
    }
}
