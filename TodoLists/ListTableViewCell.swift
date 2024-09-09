import Foundation
import UIKit

class ListTableViewCell: UITableViewCell, UITextViewDelegate {
    @IBOutlet weak var name: UITextView!
    @IBOutlet weak var todo: UITextView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var switchYesNo: UISwitch!
    
    var todoItem: TodoList?
    var viewController: ViewController?
                
        override func awakeFromNib() {
            super.awakeFromNib()
            todo.delegate = self
            name.delegate = self
        }
          
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n" {
                textView.resignFirstResponder()
                return false
            }
            return true
        }
        
    func configCell(todoText: String, nameText: String, dateText: String, isCompleted: Bool, todoItem: TodoList) {
        self.todo.text = todoText
        self.name.text = nameText
        self.date.text = dateText
        self.switchYesNo.isOn = isCompleted
        self.todoItem = todoItem

        updateTodoTEXTAPPERANCE(IsCompleted: isCompleted)
        
        switchYesNo.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
    }

        
    @objc private func switchValueChanged(_ sender: UISwitch) {
        guard let todoItem = todoItem else { return }
        todoItem.completed = sender.isOn
        CoreDataService.shared.saveContext()
        
        updateTodoTEXTAPPERANCE(IsCompleted: sender.isOn)
            viewController?.updateTableView()
                      
        
    }

        
    private func updateTodoTEXTAPPERANCE(IsCompleted: Bool) {
        let attributes: [NSAttributedString.Key: Any] = IsCompleted ? [
            .strikethroughStyle: NSUnderlineStyle.single.rawValue
        ] : [:]
        if let nameText = name.text {
            let attributedName = NSAttributedString(string: nameText, attributes: attributes)
            name.attributedText = attributedName
        }

        if let todoText = todo.text {
            let attributedTodo = NSAttributedString(string: todoText, attributes: attributes)
            todo.attributedText = attributedTodo
        }
      


                      
        
    }


        
    func textViewDidEndEditing(_ textView: UITextView) {
          guard let todoItem = todoItem else { return }
          
          DispatchQueue.main.async {
              if textView == self.name {
                  todoItem.name = textView.text
              } else if textView == self.todo {
                  todoItem.todo = textView.text
              }
              let date = Date()
              let calendar = Calendar.current

              let oneHourLater = calendar.date(byAdding: .hour, value: 1, to: date)!

              let dateFormatter = DateFormatter()
              dateFormatter.dateFormat = " h:mm a"
              dateFormatter.locale = Locale(identifier: "en_US_POSIX")
              
              let currentTime = dateFormatter.string(from: date)
              let oneHourLaterTime = dateFormatter.string(from: oneHourLater)

              let timeLoading = "Today \(currentTime) - \(oneHourLaterTime)"
              self.date.text = timeLoading // Update the date label in the cell
              todoItem.time = timeLoading
              
              CoreDataService.shared.saveContext()
              print("Изменения сохранены: \(textView.text ?? "")")
          }
      }
    }
