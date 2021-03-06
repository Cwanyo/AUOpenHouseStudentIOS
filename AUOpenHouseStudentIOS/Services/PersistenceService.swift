//
//  PersistenceService.swift
//  AUOpenHouseStudentIOS
//
//  Created by ios-project on 9/6/2561 BE.
//

import Foundation
import CoreData

class PresistenceService {
    
    // MARK: - Core Data stack
    
    private init(){}
    
    static var context: NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "AUOpenHouseStudentIOS")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    static func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("Data saved")
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    static func loadFaculties() -> [Faculty] {
        let fetchRequest: NSFetchRequest<Faculty> = Faculty.fetchRequest()
        do {
            let f = try context.fetch(fetchRequest)
            print("CoreData : loadFaculties")
            return f
        } catch(let err) {
            print("CoreData Error: loadFaculties", err)
            return [Faculty]()
        }
    }
    
    static func deleteFaculties(){
        
        let fetchRequest: NSFetchRequest<Faculty> = Faculty.fetchRequest()
        
        do {
            if let result = try? PresistenceService.context.fetch(fetchRequest) {
                for object in result {
                    context.delete(object)
                }
            }
            
            try context.save()
            print("CoreData : deleteFaculties")
        } catch(let err){
            print("CoreData Error: deleteFaculties", err)
        }
        
    }
    
    static func loadMyEvents() -> [Event] {
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        do {
            let e = try context.fetch(fetchRequest)
            print("CoreData : loadMyEvents")
            return e
        } catch(let err) {
            print("CoreData Error: loadMyEvents", err)
            return [Event]()
        }
    }
    
    static func deleteMyEvents(){
        
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        
        do {
            if let result = try? PresistenceService.context.fetch(fetchRequest) {
                for object in result {
                    context.delete(object)
                }
            }
            
            try context.save()
            print("CoreData : deleteMyEvents")
        } catch(let err){
            print("CoreData Error: deleteMyEvents", err)
        }
        
    }
    
}
