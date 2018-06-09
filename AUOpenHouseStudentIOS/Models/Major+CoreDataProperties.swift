//
//  Major+CoreDataProperties.swift
//  AUOpenHouseStudentIOS
//
//  Created by ios-project on 10/6/2561 BE.
//
//

import Foundation
import CoreData


extension Major {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Major> {
        return NSFetchRequest<Major>(entityName: "Major")
    }

    @NSManaged public var fid: Int32
    @NSManaged public var info: String?
    @NSManaged public var mid: Int32
    @NSManaged public var name: String?
    @NSManaged public var website: URL?
    @NSManaged public var faculty: Faculty?

}
