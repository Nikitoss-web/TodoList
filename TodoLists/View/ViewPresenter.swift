import Foundation

protocol ViewToPresenterProtocol: AnyObject {
    func viewDidLoad()
    func numberOfRowsInSection() -> Int
    func todoItem(at index: Int) -> TodoList?
    func deleteTodoItem(at index: Int)
    func quantityAll() -> Int
    func quantity() -> (Int, Int)
    func authorizationButtonTapped()
    func installationTodayDate() -> String
}

protocol InteractorToPresenterProtocol: AnyObject {
    func dataFetched(_ data: [TodoList])
}

class Presenter: ViewToPresenterProtocol {
    var view: PresenterToViewProtocol?
    var interactor: PresenterToInteractorProtocol?
    var router: PresenterToRouterProtocol?
    
    func viewDidLoad() {
        interactor?.fetchData()
    }
    
    func numberOfRowsInSection() -> Int {
        return CoreDataService.shared.fetchData()?.count ?? 0
    }
    
    func todoItem(at index: Int) -> TodoList? {
        return CoreDataService.shared.fetchData()?[index]
    }
    
    func deleteTodoItem(at index: Int) {
        interactor?.deleteTodoItem(at: index)
    }
    
    func quantityAll() -> Int {
        return CoreDataService.shared.fetchData()?.count ?? 0
    }
    
    func installationTodayDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM"
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: date)
    }
    
    func quantity() -> (Int, Int) {
        var open = 0
        var closed = 0
        if let todoLists = CoreDataService.shared.fetchData() {
            for todo in todoLists {
                if todo.completed {
                    open += 1
                } else {
                    closed += 1
                }
            }
        }
        return (open, closed)
    }
    
    func authorizationButtonTapped() {
        router?.pushToAddNewTaskViewController()
    }
}

extension Presenter: InteractorToPresenterProtocol {
    func dataFetched(_ data: [TodoList]) {
        DispatchQueue.main.async {
            self.view?.updateUI(with: data)
        }
    }
}
