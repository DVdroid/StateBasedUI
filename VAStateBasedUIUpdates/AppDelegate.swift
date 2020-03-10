//
//  AppDelegate.swift
//  VAStateBasedUIUpdates
//
//  Created by Vikash Anand on 07/03/20.
//  Copyright © 2020 Vikash Anand. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private var hasSeenTutorial: Bool {
        get { return UserDefaults.standard.bool(forKey: "has_seen_tutorial") }
        set { UserDefaults.standard.set(newValue, forKey: "has_seen_tutorial") }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        guard let rootViewController = UIStoryboard.instantiateViewcontroller(ofType: RootViewController.self) as? RootViewController else {
            return false
        }
        
        let rootNavigationController = UINavigationController(rootViewController: rootViewController)
        rootNavigationController.navigationBar.prefersLargeTitles = true
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()
        
        return true
    }
    
//    private func showTutorial() {
//        guard !UserDefaults.standard.bool(forKey: "has_seen_tutorial") else { return }
    
//        //Logic to show tutorial
//        UserDefaults.standard.set(true, forKey: "has_seen_tutorial")
//    }
    
    private func showTutorial() {
        guard !self.hasSeenTutorial else { return }
        
        //Logic to show tutorial
        hasSeenTutorial = true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

