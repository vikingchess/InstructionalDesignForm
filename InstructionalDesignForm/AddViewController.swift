//
//  AddViewController.swift
//  InstructionalDesignForm
//
//  Created by David Flom on 5/9/18.
//  Copyright © 2018 David Flom. All rights reserved.
//
//  TODO complete clear form
//  TODO complete save action
//  TODO add remaining tranfer variables both on add and viewcontrller pages
//  TODO next version have image fill entire screen when tapped



import UIKit
import CoreData

class AddViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: - Properties
    var coreDataStack: CoreDataStack!
    let imagePicker = UIImagePickerController()
    //setup auto start date label formatting Date to String
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    var statusRow: Int = 0
    // Initialize date variable for use
    var todaysDate = NSDate()
    var selectedDate: Date = Date()
    // Variables for transferring infromation between views
    var moveID: Int = 0
    var moveData: [Project] = []
    var moveName: String?
    var moveStartDate: Date?
    var moveDueDate: Date?
    var moveCourse: String?
    var moveDescription: String?
    var moveInstructor: String?
    var moveLocation: String?
    var moveLO: String?
    var moveLA: String?
    var movePre:String?
    var moveFormative: String?
    var moveSummative: String?
    var moveUDL: String?
    var moveNotes: String?
    var moveStatus: String?
    var moveImage: UIImage?

    
    //MARK: - Outlets
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var nameField: IDTextField!
    @IBOutlet weak var courseField: IDTextField!
    @IBOutlet weak var descriptionField: IDTextField!
    @IBOutlet weak var instructorField: IDTextField!
    @IBOutlet weak var locationField: IDTextField!
    @IBOutlet weak var learningObjectivesField: IDTextView!
    @IBOutlet weak var learningActvitiesField: IDTextView!
    @IBOutlet weak var preassessmentField: IDTextView!
    @IBOutlet weak var formativeField: IDTextView!
    @IBOutlet weak var summativeField: IDTextView!
    @IBOutlet weak var udlField: IDTextView!
    @IBOutlet weak var notesField: IDTextView!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var statusPicker: UIPickerView!
    @IBOutlet weak var imageField: UIImageView!
    // Status list for picker
    // TODO future version make list customizable
    private let status = ["Started", "25% Completed", "50% completed", "75% completed", "Completed"]
    // Find row number for status, this will display the saved status for the project in the picker
    fileprivate func findStatusRowNumber() {
        if let statusRowSelector = moveStatus {
            switch statusRowSelector {
            case "Started":
                statusRow = 0
            case "25% Completed":
                statusRow = 1
            case "50% Completed":
                statusRow = 2
            case "75% Completed":
                statusRow = 3
            case "Completed":
                statusRow = 4
            default:
                statusRow = 0
            }
        }
    }
    
    fileprivate func populateDetails () {
        nameField.text = moveName
        courseField.text = moveCourse
        descriptionField.text = moveDescription
        instructorField.text = moveInstructor
        locationField.text = moveLocation
        learningObjectivesField.text = moveLO
        learningActvitiesField.text = moveLA
        preassessmentField.text = movePre
        formativeField.text = moveFormative
        summativeField.text = moveSummative
        udlField.text = moveUDL
        notesField.text = moveNotes
        imageField.image = moveImage
        findStatusRowNumber()
        statusPicker.selectRow(statusRow, inComponent: 0, animated: true)
        print("\(moveDueDate)")
        
        endDatePicker.setDate((moveDueDate! as NSDate) as Date, animated: true)
        //TODO make this an if then statement to check for a value before updating
        // Protect startdate against a nil value
        guard let date = moveStartDate as Date? else {
            return
        }
        startDate.text = dateFormatter.string(from: (date))
    }
    //MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        print("\(moveID)")
        print("\(moveData)")
        print("\(String(describing: moveName))")
        if moveName == nil {
        // Set Start date label to todays date
        startDate.text = dateFormatter.string(from: todaysDate as Date)
        // Set Due date picker to todays date
        endDatePicker.setDate(todaysDate as Date, animated: false)
            return
        } else {
        populateDetails ()
        }
    }

    //MARK: - Actions
    @IBAction func selectImage(_ sender: Any) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    //TODO Future version add ability to take a picture directly in app
    // Connects date picker data to variable for saving
    @IBAction func onButtonPressed(_ sender: Any) {
        //selectedDate = endDatePicker.date
        guard let selectedDueDate = endDatePicker.date as Date? else {
            return
        }
        selectedDate = selectedDueDate
        
    }
    @IBAction func saveAction(_ sender: Any) {
        //TODO Need to advance out of last field or receive anr error saving problem with text views?
        let currentData = Project(context: self.coreDataStack.managedContext)
        currentData.name = nameField.text
        currentData.course = courseField.text
        currentData.descriptiom = descriptionField.text
        currentData.instructor = instructorField.text
        currentData.location = locationField.text
        currentData.learningobjectives = learningObjectivesField.text
        currentData.learningactivities = learningActvitiesField.text
        currentData.preassessment = preassessmentField.text
        currentData.formative = formativeField.text
        currentData.summative = summativeField.text
        currentData.udl = udlField.text
        currentData.notes = notesField.text
        currentData.startdate = todaysDate
        //Convert image to NSData type for binary storage in core data
        guard let imageData = UIImageJPEGRepresentation(imageField.image!, 1) else {
            print("JPG Conversion error")
            return
        }
        let imageNSData = imageData as NSData?
        currentData.projectimage = imageNSData
        currentData.duedate = selectedDate as NSDate
        //Grab status from picker and set the status field
        let row = statusPicker.selectedRow(inComponent: 0)
        let selectedStatus = status[row]
        currentData.status = selectedStatus
        
        self.coreDataStack.saveContext()
        clearForm()
    }
    
    @IBAction func newAction(_ sender: Any) {
        clearForm()
    }
    
    //MARK: - Picker data source methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return status.count
    }
        //MARK: - Picker delegate methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return status[row]
    }
    //MARK: - Image picker Delegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageField.image = image
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}

    //MARK: - Helper Methods
        extension AddViewController {
            func clearForm() {
                nameField.text = ""
                courseField.text = ""
                descriptionField.text = ""
                instructorField.text = ""
                locationField.text = ""
                learningObjectivesField.text = ""
                learningActvitiesField.text = ""
                preassessmentField.text = ""
                formativeField.text = ""
                summativeField.text = ""
                udlField.text = ""
                notesField.text = ""
                startDate.text = dateFormatter.string(from: todaysDate as Date)
                imageField.image = #imageLiteral(resourceName: "NoImage")
                
                reloadInputViews()
            }
        }
    //String to date funtion
    //TODO not sure if I am going to use this
extension String {
    func toDate(dateFormat format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        return dateFormatter.date(from: self)!
    }
}

