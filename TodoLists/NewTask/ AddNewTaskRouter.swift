import UIKit

protocol AddNewTaskRouterProtocol {
    func dismissModule()
}

class AddNewTaskRouter: AddNewTaskRouterProtocol {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func dismissModule() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
