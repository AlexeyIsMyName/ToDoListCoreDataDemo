//
//  StorageManager.swift
//  ToDoListCoreDataDemo
//
//  Created by ALEKSEY SUSLOV on 13.09.2022.
//

import Foundation
import CoreData

class StorageManager {
    static let shared = StorageManager()
    private init() {}
    
    // MARK: - Core Data stack
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoListCoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Core Data Saving support
    func saveContext() -> Bool {
        if context.hasChanges {
            do {
                try context.save()
                return true
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        
        return false
    }
    
    func fetchData() -> [Task] {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
        
        return []
    }
    
    func save(_ taskName: String) -> Task? {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task",
                                                                 in: context) else {
            return nil
        }
        
        guard let task = NSManagedObject(entity: entityDescription,
                                         insertInto: context) as? `Task` else {
            return nil
        }
        
        task.name = taskName
        
        if saveContext() {
            return task
        }
        
        return nil
    }
    
    func delete(task: Task) -> Bool {
        context.delete(task)
        
        if saveContext() {
            return true
        }
        
        return false
    }
    
    func edit(task: Task) {
        
        let editTask = context.object(with: task.objectID)
        print(editTask.hasChanges)
        
    }
}
