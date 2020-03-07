//
//  Utility.swift
//  VAManagerBuddy
//
//  Created by Vikash Anand on 22/02/20.
//  Copyright © 2020 Vikash Anand. All rights reserved.
//

import UIKit

protocol AddableRemoveable {
    func addAsSubView(inView superView: UIView)
    func removeAsSubViewFromSuperView()
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

extension UIAlertController {
    
    class func showAlert(inParent parent: UIViewController,
                         preferredStyle style: Style,
                         withTitle title: String,
                         alertMessage message: String,
                         andAlertActions actions: [UIAlertAction]?) {
        
        let alertVC = UIAlertController(title: title,
                                        message: message,
                                        preferredStyle: style)
        
        if let alertActions = actions {
            _ = alertActions.map{ alertVC.addAction($0) }
        }
        
        parent.popoverPresentationController?.sourceView = parent.view
        parent.popoverPresentationController?.sourceRect = CGRect(x: parent.view.bounds.width / 2.0,
                                                                  y: parent.view.bounds.height / 2.0,
                                                                  width: 1.0,
                                                                  height: 1.0)
        
        parent.present(alertVC, animated: true, completion: nil)
    }
}
