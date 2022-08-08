//
//  URL+Extension.swift
//  Week6
//
//  Created by SC on 2022/08/08.
//

import Foundation

extension URL {
    static let baseURL = "https://dapi.kakao.com/v2/search/"
    
    static func makeEndpointString(_ endpoint: String) -> String {
        return baseURL + endpoint
    }
}
