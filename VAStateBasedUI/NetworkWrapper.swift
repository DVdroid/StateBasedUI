//
//  NetworkWrapper.swift
//  VAManagerBuddy
//
//  Created by Vikash Anand on 22/02/20.
//  Copyright © 2020 Vikash Anand. All rights reserved.
//

import UIKit

protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

extension URLSession: URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}


enum DataFetchError: Error {
    case unknown
    case noInternet
    case badResponse
    case noRecords
}

extension DataFetchError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unknown:
            return NSLocalizedString("Something went wrong. Please try again later.", comment: "Error")
        case .badResponse:
            return NSLocalizedString("Response is not in appropriate format.", comment: "Bad Response")
        case .noInternet:
            return NSLocalizedString("Please check your internet connetion.", comment: "No Internet")
        case .noRecords:
            return NSLocalizedString("No records to show.", comment: "No Records")
        }
    }
}


final class NetworkFetcher: DataFetchable {
    
    private var members: [Member]?
    private var memberResponse: MemberResponse?

    func fetchData<T: Decodable>(result: @escaping (Result<T, DataFetchError>) -> Void) {
        NetworkWrapper.sharedInstance.makeNetworkRequest(endPoint: EndPoint(path: "/api/?results=20"),
                                                                   modelResponse: T.self,
                                                                          result: result)
    }
}


final class NetworkWrapper {
    
    static let sharedInstance = NetworkWrapper()
    private init(){}
    
    func makeNetworkRequest<T: Decodable>(endPoint: EndPoint,
                                          using session: URLSessionProtocol = URLSession.shared,
                                          modelResponse: T.Type,
                                          result: @escaping (Result<T, DataFetchError>) -> Void)
    {
        DispatchQueue.global(qos: .background).async {
            
            //To simulate no network connection
            if Int.random(in: 1...4) % 2 == 0 {
                DispatchQueue.main.async {
                    result(.failure(DataFetchError.noInternet))
                }
            } else {
                
                //To simulate incorrct json format
                let content = Int.random(in: 1...4) % 2 == 0 ? readDummyJSONResonse()! : Data()
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    
                    do {
                        let decoder = JSONDecoder()
                        let myNewObject = try decoder.decode(T.self, from: content)
                        result(.success(myNewObject))
                    } catch { let error = error as NSError
                        debugPrint(error.userInfo.debugDescription)
                        debugPrint(DataFetchError.badResponse.errorDescription!)
                        result(.failure(DataFetchError.badResponse))
                        return
                    }
                }
            }
        }
    }
}

