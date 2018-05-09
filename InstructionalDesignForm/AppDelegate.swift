//
//  AppDelegate.swift
//  InstructionalDesignForm
//
//  Created by David Flom on 5/9/18.
//  Copyright © 2018 David Flom. All rights reserved.
//

import UIKit
import CoreData

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
        importDataIfNeeded()
        return true
    }
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        coreDataStack.saveContext()
    }
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        coreDataStack.saveContext()
    }
    
     func importDataIfNeeded() {
     let fetchRequest = NSFetchRequest<Data>(entityName: "Data")
     let count = try! coreDataStack.managedContext.count(for: fetchRequest)
     guard count == 0 else {return}
     
     do {
     let results = try coreDataStack.managedContext.fetch(fetchRequest)
     results.forEach({coreDataStack.managedContext.delete($0) })
     coreDataStack.saveContext()
     importSeedData()
     } catch let error as NSError {
     print("Error fetching: \(error), \(error.userInfo)")
     }
     }
     func importSeedData () {
     let seedData = Data(context: coreDataStack.managedContext)
     seedData.name = "Seed Data Name"
     seedData.course = "Seed Data Course Name"
     seedData.descriptiom = "Seed Data Description"
     coreDataStack.saveContext()
     }
    
}

