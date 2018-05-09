//
//  FilterSortViewController:TableViewController.swift
//  InstructionalDesignForm
//
//  Created by David Flom on 5/9/18.
//  Copyright © 2018 David Flom. All rights reserved.
//

import UIKit
import CoreData

class FilterSortViewController_TableViewController: UITableViewController {
    // MARK: - Properties
        var coreDataStack: CoreDataStack!
    lazy var totalNumberOfProjects: NSPredicate = {
        return NSPredicate(format: "%K LIKE[c] %@", #keyPath(Data.name),"*")
    }()
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var numberOfProjects: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateNumberOfProjects()

    }
}
//MARK: - Helper methods
extension FilterSortViewController_TableViewController {
    func populateNumberOfProjects(){
        let fetchRequest = NSFetchRequest<NSNumber>(entityName: "Data")
        fetchRequest.resultType = .countResultType
        fetchRequest.predicate = totalNumberOfProjects
        do {
            let countResult = try coreDataStack.managedContext.fetch(fetchRequest)
            let count = countResult.first!.intValue
            numberOfProjects.text = "\(count) Total Projects"
        } catch let error as NSError {
            print("could not fetch \(error)")
        }
    }
}



