//
//  CoreDateService.swift
//  TodoLists
//
//  Created by НИКИТА ПЕСНЯК on 5.09.24.
//

import Foundation
import CoreData
final class CoreDataService {
    static var shared = CoreDataService()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodoLists")
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
    
    func saveData(with dummyjsonResult: [DummyjsonResult]) {
        context.perform { [weak self] in
            guard let self = self else { return }
            for dummyjsonResults in dummyjsonResult {
                let todoList = TodoList(context: self.context)
                todoList.id = Int16(dummyjsonResults.id)
                todoList.completed = dummyjsonResults.completed
                todoList.userId = Int16(dummyjsonResults.userId)
                todoList.name =  dummyjsonResults.todo.components(separatedBy: " ").prefix(3).joined(separator: " ")
                todoList.todo = dummyjsonResults.todo
            }
            self.saveContext()
        }
    }
    func fetchData() -> [TodoList]? {
        let fetchRequest: NSFetchRequest<TodoList> = TodoList.fetchRequest()
        
        do {
            let todoLists = try context.fetch(fetchRequest)
            return todoLists
        } catch {
            print("Failed to fetch data: \(error.localizedDescription)")
            return nil
        }
    }
    
    func deleteAllData() {
        // Создайте запрос с явным указанием имени сущности
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "TodoList")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
            print("Все данные успешно удалены.")
        } catch {
            print("Ошибка при удалении данных: \(error.localizedDescription)")
        }
    }

    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
