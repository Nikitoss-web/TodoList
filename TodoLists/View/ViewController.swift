import UIKit
import Foundation

protocol PresenterToViewProtocol: AnyObject {
    func updateUI(with data: [TodoList])
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PresenterToViewProtocol {
    @IBOutlet weak var todayDate: UILabel!
    @IBOutlet weak var openTask: UILabel!
    @IBOutlet weak var closedTask: UILabel!
    @IBOutlet weak var allTask: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var presenter: ViewToPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todayDate.text = presenter?.installationTodayDate()
        presenter?.viewDidLoad()
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewDidLoad()  
    }
    
    
    func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func updateUI(with data: [TodoList]) {
        tableView.reloadData()
        allTask.text = String(presenter?.quantityAll() ?? 0)
        openTask.text = String(presenter?.quantity().1 ?? 0)
        closedTask.text = String(presenter?.quantity().0 ?? 0)
    }
    
    
    @IBAction private func authorizationButton() {
        presenter?.authorizationButtonTapped()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as? ListTableViewCell
        if let todoItem = presenter?.todoItem(at: indexPath.row) {
            cell?.configCell(
                todoText: todoItem.todo ?? "",
                nameText: todoItem.name ?? "",
                dateText: todoItem.time ?? "",
                isCompleted: todoItem.completed,
                todoItem: todoItem
            )
        }
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter?.deleteTodoItem(at: indexPath.row)
        }
    }
}
