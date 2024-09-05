//
//  ViewController.swift
//  TodoLists
//
//  Created by НИКИТА ПЕСНЯК on 4.09.24.
//

import UIKit

class ViewController: UIViewController {
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
        tableView.dataSource = self
        allTask.text = String(quantityAll())
        openTask.text =  String(quantity().0)
        closedTask.text =  String(quantity().1)
        
//        CoreDataService.shared.deleteAllData()
        
        
        
        
//        let api = DummyjsonAPI()
//        api.dummyjson { result in
//            switch result {
//            case .success(let todos):
//                print("Загружено \(todos.count) задач:")
//                for todo in todos {
//                    print(todo.todo)
//                }
//            case .failure(let error):
//                print("Ошибка: \(error)")
//            }
//        }
    }
    @IBAction private func authorizationButton() {
        if let todoLists = CoreDataService.shared.fetchData() {
            for todo in todoLists {
                print("Todo ID: \(todo.id), Name: \(todo.name ?? "No Name"), Completed: \(todo.completed), todo: \(todo.todo ?? "")")
            }
        }
        print(quantityAll())
        print(quantity())
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
    
    
    private func timeLoadingData() -> String{
        let date = Date()
        let calendar = Calendar.current

        let oneHourLater = calendar.date(byAdding: .hour, value: 1, to: date)!

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = " h:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let currentTime = dateFormatter.string(from: date)
        let oneHourLaterTime = dateFormatter.string(from: oneHourLater)

        // Выводим строку
        let timeLoading = "Today \(currentTime) - \(oneHourLaterTime)"
        return timeLoading
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
    
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreDataService.shared.fetchData()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as? ListTableViewCell
            
            if let todoLists = CoreDataService.shared.fetchData() {
                let todo = todoLists[indexPath.row]
                cell?.todo.text = todo.todo
                cell?.name.text = todo.name
                cell?.date.text = timeLoadingData()
            }
            return cell ?? UITableViewCell()
        }
}

