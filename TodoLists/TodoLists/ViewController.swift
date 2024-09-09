//
//  ViewController.swift
//  TodoLists
//
//  Created by НИКИТА ПЕСНЯК on 4.09.24.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var todayDate: UILabel!
    @IBOutlet weak var openTask: UILabel!
    @IBOutlet weak var closedTask: UILabel!
    @IBOutlet weak var allTask: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private var tests: [DummyjsonResponse] = []
    var testLoaded: (() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        installationTodayDate()
        checkingDatabase()
        tableView.dataSource = self
        tableView.delegate = self
        allTask.text = String(quantityAll())
        openTask.text =  String(quantity().0)
        closedTask.text =  String(quantity().1)
        
        
        
        
       // CoreDataService.shared.deleteAllData()
        
        
        
        
    }
    
    
    
    func updateTableView() {
        tableView.reloadData()
        allTask.text = String(quantityAll())
        openTask.text = String(quantity().0)
        closedTask.text = String(quantity().1)
    }

    func updateTableView1() {
       
        openTask.text = String(quantity().0)
        closedTask.text = String(quantity().1)
    }

    
    @IBAction private func authorizationButton() {
        let mainStorybord = UIStoryboard(name: "AddNewTask", bundle: nil)
          let addNewTaskVC = mainStorybord.instantiateViewController(identifier: "AddNewTaskView") as! AddNewTaskView
          addNewTaskVC.viewController = self  // Передайте текущий контроллер
          navigationController?.pushViewController(addNewTaskVC, animated: true)
      }
    
    
    private func installationTodayDate(){
        let date = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "EEEE, d MMMM"
        dateFormatter.locale = Locale(identifier: "en_US")
        
        let formattedDate = dateFormatter.string(from: date)
        todayDate.text = formattedDate
        print(formattedDate)
        
    }
    
    
    
    private func quantityAll() -> Int{
        let todoLists = CoreDataService.shared.fetchData()
        return todoLists?.count ?? 0
    }
    
    private func quantity() -> (Int, Int){
        var open = 0
        var closed = 0
        if let todoLists = CoreDataService.shared.fetchData() {
            for todo in todoLists {
                if todo.completed == true{
                    open += 1
                }
                else {
                    closed += 1
                }
            }
        }
        return (open, closed)
    }
    
    private func checkingDatabase() {
       
        let todoLists = CoreDataService.shared.fetchData()
       
        if todoLists?.count == 0 {
           
                let api = DummyjsonAPI()
            
                api.dummyjson { [weak self]  result in
                    switch result {
                    case .success(let todos):
                        print("Загружено \(todos.count) задач:")
                        for todo in todos {
                            print(todo.todo)
                        }
                        DispatchQueue.main.async {
                    self?.updateTableView()  
                                      }
                    case .failure(let error):
                        print("Ошибка: \(error)")
                    }
                
            }
            self.updateTableView()
        }
            else {
                self.tableView.reloadData()
                
            }
           
        }
    }




extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreDataService.shared.fetchData()?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as? ListTableViewCell
        
        if let todoLists = CoreDataService.shared.fetchData() {
            let todo = todoLists[indexPath.row]
            cell?.configCell(todoText: todo.todo ?? "", nameText: todo.name ?? "", dateText: todo.time ?? "", isCompleted: todo.completed, todoItem: todo)
        }

        return cell ?? UITableViewCell()
    }



    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let todoLists = CoreDataService.shared.fetchData(){
                let todoToDelete = todoLists[indexPath.row]
                CoreDataService.shared.delete(todoToDelete)
                tableView.deleteRows(at: [indexPath], with: .fade)
                allTask.text = String(quantityAll())
                openTask.text =  String(quantity().0)
                closedTask.text =  String(quantity().1)
                
            }
        }
    }
}


