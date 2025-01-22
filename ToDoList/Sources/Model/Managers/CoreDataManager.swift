//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Nurlybaqyt Begaly on 15.01.2025.
//
import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    //MARK: - Fetch data
    func fetch() -> [Task]{
        var tasks = [Task]()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let context = appDelegate?.persistentContainer.viewContext else {fatalError()}
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        
        do {
            try tasks = context.fetch(fetchRequest) as? [Task] ?? [Task]()
        } catch {
            print("Error during fetching data \(error)")
        }
        return tasks
    }
    
    //MARK: - Save data
    func save(title: String, detail: String, isCompleted: Bool) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let context = appDelegate?.persistentContainer.viewContext else { return }
        guard let nameObject = NSEntityDescription.entity(forEntityName: "Task", in: context) else {return}
        
        let list = Task(entity: nameObject, insertInto: context)
        list.title = title
        list.details = detail
        list.isCompleted = isCompleted
        list.dateCreated = Date()
        
        do {
            try context.save()
            print("Saved")
        } catch {
            print("Error has been occured \(error)")
        }
    }
    
    //MARK: - Update data
    func update(updatedTask: Task) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let context = appDelegate?.persistentContainer.viewContext else { return }
        
        do {
            try context.save()
            print("Date updated")
        } catch {
            print("Error has been occured \(error)")
        }
    }
    
    //MARK: - Delete data
    func delete(taskEntity: Task) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let context = appDelegate?.persistentContainer.viewContext else { return }
        context.delete(taskEntity)
        
        do {
            try context.save()
            print("Data deleted")
        } catch {
            print("Error has been occured during deleting data \(error)")
        }
    }
}
