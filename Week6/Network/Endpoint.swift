//
//  Endpoint.swift
//  Week6
//
//  Created by SC on 2022/08/08.
//

import Foundation

// enum에서 저장 프로퍼티는 못 쓰고 연산 프로퍼티 쓸 수 있는 이유? ☘️
enum Endpoint {
//    static let blog = "\(URL.baseURL)book"
//    static let cafe = "\(URL.baseURL)cafe"
    case blog
    case cafe
    
    // 저장 프로퍼티를 못 쓰는 이유? 초기화 구문이 없어서
    var requestURL: String {
        switch self {
            case .blog:
                return URL.makeEndpointString("blog?query=")
            case .cafe:
                return URL.makeEndpointString("cafe?query=")
        }
    }
}
