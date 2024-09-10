//import Foundation
//
//protocol ListCellInteractorProtocol {
//    func updateCompletionStatus(todoItem: TodoList, isCompleted: Bool)
//    func updateTodoName(todoItem: TodoList, newName: String)
//    func updateTodoText(todoItem: TodoList, newTodo: String)
//}
//
//class ListCellInteractor: ListCellInteractorProtocol {
//    let coreDataService: CoreDataServiceProtocol
//
//    init(coreDataService: CoreDataServiceProtocol) {
//        self.coreDataService = coreDataService
//    }
//
//    func updateCompletionStatus(todoItem: TodoList, isCompleted: Bool) {
//        todoItem.completed = isCompleted
//        coreDataService.saveContext()
//    }
//
//    func updateTodoName(todoItem: TodoList, newName: String) {
//        todoItem.name = newName
//        coreDataService.saveContext()
//    }
//
//    func updateTodoText(todoItem: TodoList, newTodo: String) {
//        todoItem.todo = newTodo
//        coreDataService.saveContext()
//    }
//}
