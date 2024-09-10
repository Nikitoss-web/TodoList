import UIKit

protocol ListCellRouterProtocol {
    func navigateToDetailScreen(from view: UIViewController, with todoItem: TodoList)
}

class ListCellRouter: ListCellRouterProtocol {
    func navigateToDetailScreen(from view: UIViewController, with todoItem: TodoList) {
       
    }
}
