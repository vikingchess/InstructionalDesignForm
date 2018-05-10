//
//  AddViewController.swift
//  InstructionalDesignForm
//
//  Created by David Flom on 5/9/18.
//  Copyright © 2018 David Flom. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
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
    var moveName: String = ""

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
    //Status list for picker
    private let status = ["Started", "25% Completed", "50% completed", "75% completed", "Completed"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(moveID)")
        print("\(moveData)")
        print("\(moveName)")
        nameField.text = moveName
        startDate.text = dateFormatter.string(from: todaysDate as Date)
        
    }

    //MARK: Actions
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
extension AddViewController {
    func clearForm() {
        nameField.text = ""
        courseField.text = ""
        descriptionField.text = ""
        reloadInputViews()
    }
}

