//
//  Faculty+CoreDataProperties.swift
//  AUOpenHouseStudentIOS
//
//  Created by ios-project on 10/6/2561 BE.
//
//

import Foundation
import CoreData


extension Faculty {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Faculty> {
        return NSFetchRequest<Faculty>(entityName: "Faculty")
    }

    @NSManaged public var fid: Int32
    @NSManaged public var icon: URL?
    @NSManaged public var info: String?
    @NSManaged public var location_latitude: Double
    @NSManaged public var location_longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var website: URL?
    @NSManaged public var majors: NSSet?

}

// MARK: Generated accessors for majors
extension Faculty {

    @objc(addMajorsObject:)
    @NSManaged public func addToMajors(_ value: Major)

    @objc(removeMajorsObject:)
    @NSManaged public func removeFromMajors(_ value: Major)

    @objc(addMajors:)
    @NSManaged public func addToMajors(_ values: NSSet)

    @objc(removeMajors:)
    @NSManaged public func removeFromMajors(_ values: NSSet)

}
