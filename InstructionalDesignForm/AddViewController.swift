//
//  AddViewController.swift
//  InstructionalDesignForm
//
//  Created by David Flom on 5/9/18.
//  Copyright © 2018 David Flom. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController {
    var coreDataStack: CoreDataStack!
    //Variables for transferring infromation between views
    var moveID: Int = 0
    var moveData: [Data] = []
    var moveName: String = ""

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var courseField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    
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
        self.coreDataStack.saveContext()
        print("Current name is \(currentName)")
        clearForm()
    }
    
    @IBAction func newAction(_ sender: Any) {
        clearForm()
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
