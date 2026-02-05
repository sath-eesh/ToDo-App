import Foundation
import SwiftData
import SwiftUI

@Observable
class TodoListViewModel {
    var modelContext: ModelContext?
    
    // Logic to verify if a date is today
    func isToday(date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }
    
    // Add a new task
    func addTask(title: String) {
        guard
            let context = modelContext,
            !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else { return }
        
        let newTask = TodoItem(title: title)
        context.insert(newTask)
    }
    
    // Toggle completion status
    func toggleCompletion(for item: TodoItem) {
        item.isCompleted.toggle()
    }
    
    // Delete a task
    func deleteTask(item: TodoItem) {
        modelContext?.delete(item)
    }
    
    // Clean up old tasks (not from today)
    func cleanUpOldTasks() {
        guard let context = modelContext else { return }
        
        do {
            let descriptor = FetchDescriptor<TodoItem>()
            let allItems = try context.fetch(descriptor)
            
            for item in allItems {
                if !isToday(date: item.createdAt) {
                    context.delete(item)
                }
            }
        } catch {
            print("Failed to clear old tasks: \(error)")
        }
    }
}
