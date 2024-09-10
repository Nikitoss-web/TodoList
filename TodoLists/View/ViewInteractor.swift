import Foundation

protocol PresenterToInteractorProtocol: AnyObject {
    func fetchData()
    func deleteTodoItem(at index: Int)
    func updateTodoItem(_ todoItem: TodoList)
}

class Interactor: PresenterToInteractorProtocol {
    var presenter: InteractorToPresenterProtocol?
    
    func fetchData() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            let todoLists = CoreDataService.shared.fetchData() ?? []
            
            let isFirstLaunch = !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
            
            if isFirstLaunch {
                UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
                
                let api = DummyjsonAPI()
                api.dummyjson { [weak self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let todos):
                            print("Загружено \(todos.count) задач:")
                            for todo in todos {
                                print(todo.todo)
                            }
                            self?.presenter?.dataFetched(todoLists)
                        case .failure(let error):
                            print("Ошибка: \(error)")
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self?.presenter?.dataFetched(todoLists)
                }
            }
        }
    }
    
    func deleteTodoItem(at index: Int) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            if let todoLists = CoreDataService.shared.fetchData() {
                let todoToDelete = todoLists[index]
                CoreDataService.shared.delete(todoToDelete)
                self?.fetchData()
            }
        }
    }
    
    func updateTodoItem(_ todoItem: TodoList) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            CoreDataService.shared.saveContext()
            self?.fetchData()
        }
    }
}
