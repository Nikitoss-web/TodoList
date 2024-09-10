import Foundation

protocol AddNewTaskPresenterProtocol {
    func addTask(name: String, todo: String)
}

class AddNewTaskPresenter: AddNewTaskPresenterProtocol {
    weak var view: AddNewTaskViewProtocol?
    private let interactor: AddNewTaskInteractorProtocol
    private let router: AddNewTaskRouterProtocol
    
    init(view: AddNewTaskViewProtocol, interactor: AddNewTaskInteractorProtocol, router: AddNewTaskRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func addTask(name: String, todo: String) {
        interactor.addTask(name: name, todo: todo) { [weak self] success in
            if success {
                self?.router.dismissModule()
            } else {
                self?.view?.showError("Failed to add task")
            }
        }
    }
}
