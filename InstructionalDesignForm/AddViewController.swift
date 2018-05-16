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
    //var moveEndDate: Date = NSDate() as Date
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
        //TODO need to figure how to move status
        //TODO need to figure how to move image
        //TODO need to figure how to move dates
        //TODO make this an if then statement to check for a value before updating
        // Protect startdate against a nil value
        guard let date = moveStartDate as Date? else {
            return
        }
        startDate.text = dateFormatter.string(from: (date))
        
        //endDatePicker.date = moveEndDate
    }
    //MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        print("\(moveID)")
        print("\(moveData)")
        print("\(String(describing: moveName))")
        if moveName == nil {
        startDate.text = dateFormatter.string(from: todaysDate as Date)
            return
        } else {
        populateDetails ()
        }
    }

    //MARK: - Actions
    //TODO add save contect for remaining fields
    @IBAction func selectImage(_ sender: Any) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    //TODO Future version add ability to take a picture directly in app
    @IBAction func saveAction(_ sender: Any) {
        //TODO Need to advance out of last field or receive anr error saving problem with text views?
        let currentData = Data(context: self.coreDataStack.managedContext)
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
        //TODO Add code to clear remaining fields
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

