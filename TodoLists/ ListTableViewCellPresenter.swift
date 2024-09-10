//import Foundation
//
//protocol ListCellPresenterProtocol {
//    func toggleTodoCompletion(isCompleted: Bool)
//    func updateTodoName(newName: String)
//    func updateTodoText(newTodo: String)
//}
//
//class ListCellPresenter: ListCellPresenterProtocol {
//    weak var view: ListViewCellProtocol?
//    var interactor: ListCellInteractorProtocol
//    var router: ListCellRouterProtocol
//
//    var todoItem: TodoList
//
//    init(view: ListViewCellProtocol, interactor: ListCellInteractorProtocol, router: ListCellRouterProtocol, todoItem: TodoList) {
//        self.view = view
//        self.interactor = interactor
//        self.router = router
//        self.todoItem = todoItem
//    }
//
//    func toggleTodoCompletion(isCompleted: Bool) {
//        interactor.updateCompletionStatus(todoItem: todoItem, isCompleted: isCompleted)
//        view?.updateTodoTextAppearance(isCompleted: isCompleted)
//    }
//
//    func updateTodoName(newName: String) {
//        interactor.updateTodoName(todoItem: todoItem, newName: newName)
//    }
//
//    func updateTodoText(newTodo: String) {
//        interactor.updateTodoText(todoItem: todoItem, newTodo: newTodo)
//    }
//}
