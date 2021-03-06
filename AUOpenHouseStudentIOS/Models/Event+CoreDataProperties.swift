//
//  Event+CoreDataProperties.swift
//  AUOpenHouseStudentIOS
//
//  Created by ios-project on 10/6/2561 BE.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var eid: Int32
    @NSManaged public var faculty_name: String?
    @NSManaged public var fid: Int32
    @NSManaged public var icon: URL?
    @NSManaged public var image: URL?
    @NSManaged public var info: String?
    @NSManaged public var location_latitude: Double
    @NSManaged public var location_longitude: Double
    @NSManaged public var major_name: String?
    @NSManaged public var mid: Int32
    @NSManaged public var name: String?
    @NSManaged public var state: Int16
    @NSManaged public var tid: Int32
    @NSManaged public var time_end: String?
    @NSManaged public var time_start: String?

}
