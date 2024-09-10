import Foundation
import UIKit

protocol AddNewTaskViewProtocol: AnyObject {
    func showError(_ message: String)
}

class AddNewTaskView: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var todoTextView: UITextView!
    var presenter: AddNewTaskPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func addNewCell() {
        guard let name = nameField.text, !name.isEmpty,
              let todo = todoTextView.text, !todo.isEmpty else {
            showError("Name or todo cannot be empty")
            return
        }
        presenter?.addTask(name: name, todo: todo)
    }
}

extension AddNewTaskView: AddNewTaskViewProtocol {
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
