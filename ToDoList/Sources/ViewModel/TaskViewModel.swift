//
//  ViewController.swift
//  ToDoList
//
//  Created by Nurlybaqyt Begaly on 15.01.2025.
//

import UIKit

class TaskViewModel {
    
    private let coreDataManager = CoreDataManager.shared
    
    var tasks: [Task] = []
    var filteredTasks: [Task] = []
    var onTaskUpdated: (() -> Void)?
    
    func fetchTasks() {
        DispatchQueue.global(qos: .background).async {
            self.tasks = self.coreDataManager.fetch()
            self.filteredTasks = self.tasks
            DispatchQueue.main.async {
                self.onTaskUpdated?()
            }
        }
    }
    
    func getFormattedDate(for task: Task) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        if let date = task.dateCreated {
            return dateFormatter.string(for: date)!
        }
            return "No date"
    }
    
    func addTask(title: String, details: String) {
        DispatchQueue.global(qos: .background).async {
            self.coreDataManager.save(title: title, detail: details, isCompleted: false)
            self.fetchTasks()
        }
    }
    
    func deleteTask(at index: Int) {
        DispatchQueue.global(qos: .background).async {
            let task = self.tasks[index]
            self.coreDataManager.delete(taskEntity: task)
            self.fetchTasks()
        }
    }
    
    func filterTask(by query: String) {
        DispatchQueue.global(qos: .background).async {
            if query.isEmpty {
                self.filteredTasks = self.tasks
            } else {
                self.filteredTasks = self.tasks.filter {
                    $0.title?.localizedCaseInsensitiveContains(query) == true || $0.details?.localizedCaseInsensitiveContains(query) == true
                }
                if self.filteredTasks.isEmpty {
                    self.filteredTasks = self.tasks
                    print("Not found by query: \(query)")
                } 
            }
            DispatchQueue.main.async {
                self.onTaskUpdated?()
            }
        }
        
    }
}

