//
//  Request.swift
//  VAStateBasedUI
//
//  Created by Vikash Anand on 21/03/20.
//  Copyright © 2020 Vikash Anand. All rights reserved.
//

import Foundation

class Request {
    
    enum Method: String {
        case GET
        case POST
        case PUT
        case DELETE
        case PATCH
    }
    
    static func getRequest(ofType methodType: Method, fromURL url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = methodType.rawValue
        return request
    }
}
