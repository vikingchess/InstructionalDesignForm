//
//  AppDelegate.swift
//  InstructionalDesignForm
//
//  Created by David Flom on 5/9/18.
//  Copyright © 2018 David Flom. All rights reserved.
//

import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    lazy var coreDataStack = CoreDataStack(modelName: "InstructionalDesignForm")
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        guard let navController = window?.rootViewController as? UINavigationController,
            let viewController = navController.topViewController as? ViewController else {
                return true
        }
        viewController.coreDataStack = coreDataStack
        GADMobileAds.configure(withApplicationID: "ca-app-pub-5241767368323444~7122932500")
        return true
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        coreDataStack.saveContext()
    }
    func applicationWillTerminate(_ application: UIApplication) {
        coreDataStack.saveContext()
    }
}

