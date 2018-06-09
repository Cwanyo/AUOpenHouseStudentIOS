//
//  Faculty+CoreDataProperties.swift
//  AUOpenHouseStudentIOS
//
//  Created by ios-project on 9/6/2561 BE.
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
    @NSManaged public var location_latitude: Float
    @NSManaged public var location_longitude: Float
    @NSManaged public var name: String?
    @NSManaged public var website: URL?

}
