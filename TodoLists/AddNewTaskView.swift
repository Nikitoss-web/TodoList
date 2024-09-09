//
//  AddNewTaskView.swift
//  TodoLists
//
//  Created by НИКИТА ПЕСНЯК on 6.09.24.
//

import Foundation
import UIKit

class AddNewTaskView: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var todoTextView: UITextView!
    
    var onTaskAdded: (() -> Void)?
    var viewController: ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction private func  AddNewCell(){
        guard let name = nameField.text, !name.isEmpty,
                     let todo = todoTextView.text, !todo.isEmpty else { return }
        DispatchQueue.main.async {

         
                   let api = DummyjsonAPI()
                   CoreDataService.shared.addNewTask(name: name, todo: todo, time: api.timeLoadingData())
                   
                       self.onTaskAdded?()
                       self.navigationController?.popViewController(animated: true)
            DispatchQueue.main.async {
                self.viewController?.updateTableView() 
                          }
                   }
               }
           
   }

