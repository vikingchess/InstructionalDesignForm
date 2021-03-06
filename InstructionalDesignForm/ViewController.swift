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
    // setup auto start date label formatting
    // TODO check to see if needed on view controller
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
    lazy var fetchedResultsController: NSFetchedResultsController<Project> = {
        let fetchRequestForController: NSFetchRequest<Project> = Project.fetchRequest()
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequestForController, managedObjectContext: coreDataStack.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = (self as! NSFetchedResultsControllerDelegate)
        return fetchedResultsController
    }()
    // pulls the fetch request from the gui for the Data
    var fetchRequest: NSFetchRequest<Project>?
    // var puts the pulled data from fetch request into an array to populate the table
    var currentData: [Project] = []
    var asyncFetchRequest: NSAsynchronousFetchRequest<Project>?
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - View Life Cycle
    override func viewDidAppear(_ animated: Bool) {
            fetchAndReload()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataFetchRequest: NSFetchRequest<Project> = Project.fetchRequest()
        fetchRequest = dataFetchRequest
        asyncFetchRequest = NSAsynchronousFetchRequest<Project>(fetchRequest: dataFetchRequest) {
            [unowned self] (result: NSAsynchronousFetchResult) in
            
            guard let currentData = result.finalResult else {
                return
            }
            self.currentData = currentData
            self.tableView.reloadData()
        }
        do {
            guard let asyncFetchRequest = asyncFetchRequest else {
                return
            }
            try coreDataStack.managedContext.execute(asyncFetchRequest)
        } catch let error as NSError {
            print(" Could not fetch \(error)")
        }
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
                let addController = segue.destination as! AddViewController
                addController.coreDataStack = self.coreDataStack
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
                moveVC.moveImage = UIImage(data: data.projectimage! as Data)
                moveVC.moveStatus = data.status
                moveVC.moveDueDate = data.duedate as Date?
                moveVC.moveStartDate = data.startdate as Date?
                
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
    //MARK: - IBActions
    extension ViewController {
        @IBAction func unwindToProjectListViewController(_ segue: UIStoryboardSegue) {
            fetchAndReload()
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
        // Set end date to display as a string
        let tempEndDate = data.duedate as Date?
        let displayEndDate = dateFormatter.string(from: tempEndDate!)
        // Insert information into cells
        cell.textLabel?.text = "\(data.name!), has status \(data.status!) is due on \(displayEndDate)"
        cell.detailTextLabel?.text = "\(data.course!) is being taught by \(data.instructor!)"
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //Funtion for deleting cells with a swipe
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        guard let projectToDelete = currentData[indexPath.row] as? Project,
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

