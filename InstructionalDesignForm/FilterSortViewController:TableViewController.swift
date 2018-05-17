//
//  FilterSortViewController:TableViewController.swift
//  InstructionalDesignForm
//
//  Created by David Flom on 5/9/18.
//  Copyright © 2018 David Flom. All rights reserved.
//


import UIKit
import CoreData

protocol  FilterViewControllerDelegate: class {
    func filterViewController (
        filter: FilterSortViewController_TableViewController,
        didSelectPredicate predicate: NSPredicate?,
        sortDescriptor: NSSortDescriptor?)
}

class FilterSortViewController_TableViewController: UITableViewController {
    // MARK: - Properties
    var coreDataStack: CoreDataStack!
    weak var delegate: FilterViewControllerDelegate?
    var selectedSortDescriptor: NSSortDescriptor?
    var selectedPredicate: NSPredicate?
    
    lazy var totalNumberOfProjects: NSPredicate = {
        return NSPredicate(format: "%K LIKE[c] %@", #keyPath(Project.name),"*")
    }()
    lazy var startedProjects: NSPredicate = {
        return NSPredicate(format: "%K == %@", #keyPath(Project.status), "Started")
    }()
    lazy var completedProjects: NSPredicate = {
        return NSPredicate(format: "%K == %@", #keyPath(Project.status), "Completed")
    }()
    lazy var nameSortDescriptor: NSSortDescriptor = {
        let compareSelector = #selector(NSString.localizedStandardCompare(_:))
        return NSSortDescriptor(key: #keyPath(Project.name), ascending: true, selector: compareSelector)
    }()
    lazy var courseSortDescriptor: NSSortDescriptor = {
        let compareSelector = #selector(NSString.localizedStandardCompare(_:))
        return NSSortDescriptor(key: #keyPath(Project.course), ascending: true, selector: compareSelector)
    }()
    
    //MARK: - Actions
    @IBAction func cancelAction(_ sender: Any) {

    }
    @IBAction func searchAction(_ sender: Any) {
        delegate?.filterViewController(filter: self, didSelectPredicate: selectedPredicate, sortDescriptor: selectedSortDescriptor)
        dismiss(animated: true)
    }
    
    //MARK: - Outlets
    @IBOutlet weak var numberOfProjects: UILabel!
    @IBOutlet weak var numberOfStartedProjects: UILabel!
    @IBOutlet weak var numberOfCompletedProjects: UILabel!
    @IBOutlet weak var projectNameSort: UILabel!
    @IBOutlet weak var courseNameSort: UILabel!
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        populateNumberOfProjects()
        populateStartedProjects()
        populateCompletedProjects()

    }
}

    //MARK: - Helper methods
    extension FilterSortViewController_TableViewController {
        func populateNumberOfProjects(){
            let fetchRequest = NSFetchRequest<NSNumber>(entityName: "Project")
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
    extension FilterSortViewController_TableViewController {
        func populateStartedProjects(){
            let fetchRequest = NSFetchRequest<NSNumber>(entityName: "Project")
            fetchRequest.resultType = .countResultType
            fetchRequest.predicate = startedProjects
            do {
                let countResult = try coreDataStack.managedContext.fetch(fetchRequest)
                let count = countResult.first!.intValue
                numberOfStartedProjects.text = "\(count) projects that have been started but not worked on"
            } catch let error as NSError {
                print("could not fetch \(error)")
            }
        }
    }
    extension FilterSortViewController_TableViewController {
        func populateCompletedProjects(){
            let fetchRequest = NSFetchRequest<NSNumber>(entityName: "Project")
            fetchRequest.resultType = .countResultType
            fetchRequest.predicate = completedProjects
            do {
                let countResult = try coreDataStack.managedContext.fetch(fetchRequest)
                let count = countResult.first!.intValue
                numberOfCompletedProjects.text = "\(count) projects that have been completed"
            } catch let error as NSError {
                print("could not fetch \(error)")
            }
        }
    }

    // MARK: - UITableView Delegate
    extension FilterSortViewController_TableViewController {
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            guard let cell = tableView.cellForRow(at: indexPath) else {
                return
            }
            //Status Selection
            switch cell {
            case numberOfStartedProjects:
                selectedPredicate = startedProjects
            case numberOfCompletedProjects:
                selectedPredicate = completedProjects
            case projectNameSort:
                selectedSortDescriptor = nameSortDescriptor
            case courseNameSort:
                selectedSortDescriptor = courseSortDescriptor
                
            default:
                break
            }
            cell.accessoryType = .checkmark
        }
    }
