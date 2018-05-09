//
//  ViewController.swift
//  InstructionalDesignForm
//
//  Created by David Flom on 5/9/18.
//  Copyright © 2018 David Flom. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    // MARK: - Properties
    // Identify segues for view control name is from storyboard
    private let filterViewControllerSegueIdentifier = "toFilterViewController"
    private let detailViewControllerSegueIdentifier = "toDetailsScreen"
    // identfy cells for reuse name is from storyboard
    fileprivate let dataCellIdentifier = "DataCell"
    var coreDataStack: CoreDataStack!
    lazy var fetchedResultsController: NSFetchedResultsController<Data> = {
        let fetchRequestForController: NSFetchRequest<Data> = Data.fetchRequest()
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequestForController, managedObjectContext: coreDataStack.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self as! NSFetchedResultsControllerDelegate
        return fetchedResultsController
    }()
    // pulls the fetch request from the gui for the Data
    var fetchRequest: NSFetchRequest<Data>?
    //var puts the pulled data from fetch request into an array to populate the table
    var currentData: [Data] = []
    var asyncFetchRequest: NSAsynchronousFetchRequest<Data>?
//MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let model = coreDataStack.managedContext.persistentStoreCoordinator?.managedObjectModel,
            let fetchRequest = model.fetchRequestTemplate(forName: "FetchRequest") as? NSFetchRequest<Data> else {
                return
        }
        
        self.fetchRequest = fetchRequest
        fetchAndReload()
    }
    //MARK: - Segues
    // Navigation between views using a switch case to determine which segue to use
    // Different code because filter is a table view and details is a view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "toFilterViewController":
                let controller = segue.destination as? UINavigationController
                
                // changed FilterSortViewController to FilterSortViewController_TableViewController
                let filterVC = controller?.topViewController as? FilterSortViewController_TableViewController
                filterVC?.coreDataStack = self.coreDataStack
            case detailViewControllerSegueIdentifier:
                let controller = segue.destination as! AddViewController
                controller.coreDataStack = self.coreDataStack
            case "sendDetails":
                var selectedRowIndex = self.tableView.indexPathForSelectedRow
                let moveVC:AddViewController = segue.destination as! AddViewController
                moveVC.moveID = selectedRowIndex!.row
                moveVC.moveData = [currentData[selectedRowIndex!.row]]
                let data = currentData[selectedRowIndex!.row]
                moveVC.moveName = data.name!
                
                
            default:
                return
            }
        }
    }
}
//Mark: - Helper methods
extension ViewController {
    func fetchAndReload(){
        guard let fetchRequest = fetchRequest else {
            return
        }
        do {
            currentData = try coreDataStack.managedContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
}
// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: dataCellIdentifier, for: indexPath)
        let data = currentData[indexPath.row]
        cell.textLabel?.text = data.name
        cell.detailTextLabel?.text = data.course
        return cell
    }
}
// TODO add delete functionality
// TODO move information to detail screen

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowValue = currentData[indexPath.row]
        print("Row \(rowValue)")
        
    }
}

