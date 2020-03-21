//
//  EndPoint.swift
//  VAStateBasedUI
//
//  Created by Vikash Anand on 22/03/20.
//  Copyright © 2020 Vikash Anand. All rights reserved.
//

import Foundation

//private static let memberUrlString = "https://randomuser.me/api/?results=20"

struct EndPoint {
    let path: String
    var queryItems: [URLQueryItem]?
}

extension EndPoint {
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "randomuser.me"
        components.path = path
        components.queryItems = queryItems
        
        return components.url
    }
}

