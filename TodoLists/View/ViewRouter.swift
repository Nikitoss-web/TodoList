import UIKit

protocol PresenterToRouterProtocol: AnyObject {
    func pushToAddNewTaskViewController()
}

class Router: PresenterToRouterProtocol {
    weak var viewController: UIViewController?
    
    func pushToAddNewTaskViewController() {
        let mainStoryboard = UIStoryboard(name: "AddNewTask", bundle: nil)
        if let addNewTaskVC = mainStoryboard.instantiateViewController(identifier: "AddNewTaskView") as? AddNewTaskView {
            viewController?.navigationController?.pushViewController(AddNewTaskModuleBuilder.build(), animated: true)
        }
    }
}

