//
//  ViewController.swift
//  InstructionalDesignForm
//
//  Created by David Flom on 5/9/18.
//  Copyright © 2018 David Flom. All rights reserved.
//
//  TODO Remove unused code...seed data for sure is not needed

import UIKit
import CoreData

class ViewController: UIViewController {
    // MARK: - Properties
    //setup auto start date label formatting
    //TODO check to see if needed on view controller
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    // Identify segues for view control name is from storyboard
    private let filterViewControllerSegueIdentifier = "toFilterViewController"
    private let detailViewControllerSegueIdentifier = "toDetailsScreen"
    // Identfy storyboard cells for reuse
    fileprivate let dataCellIdentifier = "DataCell"
    var coreDataStack: CoreDataStack!
    lazy var fetchedResultsController: NSFetchedResultsController<Data> = {
        let fetchRequestForController: NSFetchRequest<Data> = Data.fetchRequest()
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequestForController, managedObjectContext: coreDataStack.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = (self as! NSFetchedResultsControllerDelegate)
        return fetchedResultsController
    }()
    // pulls the fetch request from the gui for the Data
    var fetchRequest: NSFetchRequest<Data>?
    //var puts the pulled data from fetch request into an array to populate the table
    var currentData: [Data] = []
    var asyncFetchRequest: NSAsynchronousFetchRequest<Data>?
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRequest = Data.fetchRequest()
        fetchAndReload()
    }
    
    //MARK: - Actions
    @IBAction func refreshAction(_ sender: Any) {
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
                
                let filterVC = controller?.topViewController as? FilterSortViewController_TableViewController
                filterVC?.coreDataStack = self.coreDataStack
                filterVC?.delegate = self
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
                moveVC.moveCourse = data.course!
                moveVC.moveInstructor = data.instructor
                moveVC.moveDescription = data.descriptiom
                moveVC.moveLocation = data.location
                moveVC.moveLO = data.learningobjectives
                moveVC.moveLA = data.learningactivities
                moveVC.movePre = data.preassessment
                moveVC.moveFormative = data.formative
                moveVC.moveSummative = data.summative
                moveVC.moveUDL = data.udl
                moveVC.moveNotes = data.notes
                data.startdate as Date?
                guard case moveVC.moveStartDate = data.startdate as Date? else {
                    return
                }
                //startDate.text = dateFormatter.string(from: moveStartDate as Date)
                //TODO need to figure how to move images and dates
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

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //Funtion for deleting cells with a swipe
 func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
    guard let projectToDelete = currentData[indexPath.row] as? Data,
    editingStyle == .delete else {
        return
        }
    coreDataStack.managedContext.delete(projectToDelete)
    currentData.remove(at: indexPath.row)
    coreDataStack.saveContext()
    tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowValue = currentData[indexPath.row]
        print("Row \(rowValue)")
    }
}

//MARK: - Filter view controller delegate
extension ViewController: FilterViewControllerDelegate{
    func filterViewController(filter: FilterSortViewController_TableViewController, didSelectPredicate predicate: NSPredicate?, sortDescriptor: NSSortDescriptor?) {
        guard let fetchRequest = fetchRequest else {
            return
        }
        //reset or clear predicate and sort to nil
        fetchRequest.predicate = nil
        fetchRequest.sortDescriptors = nil
        //set predicate and sort to new selections
        fetchRequest.predicate = predicate
        if let sr = sortDescriptor {
            fetchRequest.sortDescriptors = [sr]
        }
        fetchAndReload()
    }
}

