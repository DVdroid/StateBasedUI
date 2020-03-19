//
//  MemeberViewModel.swift
//  VAManagerBuddy
//
//  Created by Vikash Anand on 22/02/20.
//  Copyright © 2020 Vikash Anand. All rights reserved.
//

import Foundation

protocol DataFetchable {
    func fetchData<T: Decodable>(result: @escaping (Result<T, DataFetchError>) -> Void)
}

final class MemeberViewModel {
    
    // MARK: - Variables
    private var memberResponse: MemberResponse?
    let dataSource: DataFetchable
    
    init(_ dataSource: DataFetchable) {
        self.dataSource = dataSource
    }
    
    func getMembers<T: Decodable>(result: @escaping (Result<T, DataFetchError>) -> Void) {
        dataSource.fetchData(result: result)
    }
}

