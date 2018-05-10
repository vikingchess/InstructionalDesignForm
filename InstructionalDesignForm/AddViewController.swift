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
    //Variables for transferring infromation between views
    var moveID: Int = 0
    var moveData: [Data] = []
    var moveName: String = ""

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var courseField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
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
    }
    var currentName = "No Name Given"
    var currentCourse = "No Course Given"
    var currentDescription = "No Description Given"

    
    @IBAction func saveAction(_ sender: Any) {
        currentName = nameField.text!
        currentCourse = courseField.text!
        currentDescription = descriptionField.text!
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
        print("Current name is \(currentName)")
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

