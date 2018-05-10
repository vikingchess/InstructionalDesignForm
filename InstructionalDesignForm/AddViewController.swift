//
//  AddViewController.swift
//  InstructionalDesignForm
//
//  Created by David Flom on 5/9/18.
//  Copyright © 2018 David Flom. All rights reserved.
//
//  TODO complete clear form
//  TODO complete save action
//  TODO hook up image view
//  TODO add remaining tranfer variables both on add and viewcontrller pages



import UIKit
import CoreData

class AddViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    //MARK: - Properties
    var coreDataStack: CoreDataStack!
    //setup auto start date label formatting
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    var todaysDate = NSDate()
    //Variables for transferring infromation between views
    var moveID: Int = 0
    var moveData: [Data] = []
    var moveName: String?
    var moveStartDate: Date?
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
    var moveEndDate: Date?
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
    //Status list for picker
    private let status = ["Started", "25% Completed", "50% completed", "75% completed", "Completed"]
    
    //MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(moveID)")
        print("\(moveData)")
        print("\(String(describing: moveName))")
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
        //TODO need to figure how to move status
        //TODO need to figure how to move image
        //TODO need to figure how to move dates
        //TODO make this an if then statement to check for a value before updating
        startDate.text = dateFormatter.string(from: todaysDate as Date)
        
    }

    //MARK: - Actions
    @IBAction func saveAction(_ sender: Any) {

        let currentData = Data(context: self.coreDataStack.managedContext)
        currentData.name = nameField.text
        currentData.course = courseField.text
        currentData.descriptiom = descriptionField.text
        //Grab Date from picker and put in into the duedate field
        let date = NSDate()
        endDatePicker.setDate(date as Date, animated: false)
        currentData.duedate = date
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

}

        //MARK: - Helper Methods
        extension AddViewController {
            func clearForm() {
                nameField.text = ""
                courseField.text = ""
                descriptionField.text = ""
                reloadInputViews()
            }
        }

