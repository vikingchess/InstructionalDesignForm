//
//  Project+CoreDataProperties.swift
//  InstructionalDesignForm
//
//  Created by David Flom on 5/16/18.
//  Copyright © 2018 David Flom. All rights reserved.
//
//

import Foundation
import CoreData


extension Project {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project")
    }

    @NSManaged public var course: String?
    @NSManaged public var descriptiom: String?
    @NSManaged public var duedate: NSDate?
    @NSManaged public var formative: String?
    @NSManaged public var instructor: String?
    @NSManaged public var learningactivities: String?
    @NSManaged public var learningobjectives: String?
    @NSManaged public var location: String?
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var preassessment: String?
    @NSManaged public var projectimage: NSData?
    @NSManaged public var startdate: NSDate?
    @NSManaged public var status: String?
    @NSManaged public var summative: String?
    @NSManaged public var udl: String?

}
