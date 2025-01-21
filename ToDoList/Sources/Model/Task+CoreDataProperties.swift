//
//  Task+CoreDataProperties.swift
//  ToDoList
//
//  Created by Nurlybaqyt Begaly on 15.01.2025.
//
//

import UIKit
import CoreData

@objc(Task)
public class Task: NSManagedObject {

}

extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var title: String?
    @NSManaged public var details: String?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var isCompleted: Bool

}

extension Task : Identifiable {

}
