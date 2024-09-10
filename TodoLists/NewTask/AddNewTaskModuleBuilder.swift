import UIKit

class AddNewTaskModuleBuilder {
    static func build() -> UIViewController {
        let view = UIStoryboard(name: "AddNewTask", bundle: nil).instantiateViewController(withIdentifier: "AddNewTaskView") as! AddNewTaskView
        let interactor = AddNewTaskInteractor()
        let router = AddNewTaskRouter(viewController: view)
        let presenter = AddNewTaskPresenter(view: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        
        return view
    }
}
