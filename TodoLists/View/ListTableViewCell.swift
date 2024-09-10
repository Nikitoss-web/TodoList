import UIKit

class ListTableViewCell: UITableViewCell, UITextViewDelegate {
    @IBOutlet weak var name: UITextView!
    @IBOutlet weak var todo: UITextView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var switchYesNo: UISwitch!
    
    var todoItem: TodoList?
    var onSwitchValueChanged: ((TodoList, Bool) -> Void)?
    
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
        
        updateTodoTextAppearance(isCompleted: isCompleted)
        
        switchYesNo.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
    }
    
    @objc private func switchValueChanged(_ sender: UISwitch) {
        guard let todoItem = todoItem else { return }
        let isCompleted = sender.isOn
        todoItem.completed = isCompleted
        
        DispatchQueue.global(qos: .background).async {
            CoreDataService.shared.saveContext()
            DispatchQueue.main.async {
                self.updateTodoTextAppearance(isCompleted: isCompleted)
                self.onSwitchValueChanged?(todoItem, isCompleted)
            }
        }
    }
    
    private func updateTodoTextAppearance(isCompleted: Bool) {
        let attributes: [NSAttributedString.Key: Any] = isCompleted ? [
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
        
        DispatchQueue.global(qos: .background).async {
            if textView == self.name {
                todoItem.name = textView.text
            } else if textView == self.todo {
                todoItem.todo = textView.text
            }
            let api = DummyjsonAPI()        
            DispatchQueue.main.async {
                self.date.text = api.timeLoadingData()
                todoItem.time = api.timeLoadingData()
                CoreDataService.shared.saveContext()
                print("Изменения сохранены: \(textView.text ?? "")")
            }
        }
    }
}

