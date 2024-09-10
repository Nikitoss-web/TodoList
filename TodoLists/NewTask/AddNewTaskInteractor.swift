import Foundation

protocol AddNewTaskInteractorProtocol {
    func addTask(name: String, todo: String, completion: @escaping (Bool) -> Void)
}

class AddNewTaskInteractor: AddNewTaskInteractorProtocol {
    func addTask(name: String, todo: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let api = DummyjsonAPI()
            let success = CoreDataService.shared.addNewTask(name: name, todo: todo, time: api.timeLoadingData())
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }
}
