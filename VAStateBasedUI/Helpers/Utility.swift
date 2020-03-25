//
//  Utility.swift
//  VAManagerBuddy
//
//  Created by Vikash Anand on 22/02/20.
//  Copyright © 2020 Vikash Anand. All rights reserved.
//

import UIKit

protocol AddableRemoveable: UIView {
    func addAsSubView(inView parentView: UIView)
    func removeAsSubViewFromParentView()
}

extension UIColor {
    
    class func colorFromHex(rgbValue:UInt32, alpha:Double = 1.0) -> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
}

extension UIStoryboard {
    
    class func instantiateViewcontroller<T>(ofType type: T.Type,
                                            fromStoryboard storyBoardName: String = "Main",
                                            andBundle bundle: Bundle = .main) -> UIViewController {
        return UIStoryboard(name: storyBoardName, bundle: bundle).instantiateViewController(withIdentifier: String(describing: type))
    }
}


func readDummyJSONResonse() -> Data? {
    guard let jsonURL = Bundle.main.url(forResource: "employee", withExtension: "json") else {
        return nil
    }
    return try! Data(contentsOf: jsonURL)
}


extension Collection where Element == Member {
    
    var filteredMaleMembers: [Member] {
        return filter { $0.isMale }
    }
    
    var filteredFemaleMembers: [Member] {
        return filter { !$0.isMale }
    }
}


func configure<T>(_ value: T, using closure: (inout T) throws -> Void) rethrows -> T {
    var value = value
    try closure(&value)
    return value
}

extension Optional where Wrapped: Collection {
    public var isNilOrEmpty: Bool {
        switch self {
        case .none:
            return true
        case .some(let collection):
            return collection.isEmpty
        }
    }
}
