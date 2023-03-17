//
//  ViewController.swift
//  Notes
//
//  Created by Деним Мержан on 16.03.23.
//

import UIKit
import CoreData

class NotebookViewController: UIViewController {
    
    weak var delegate: SecondCategory?
    var category = String()
    var secondCategory: String?
    var index: Int?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var userText: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(category)
        
        if secondCategory != nil{
            loadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        if userText.text != "" || userText.text != nil {
            
            let changeCategory =  creatSecondCategory(userText: userText.text!)
            print(secondCategory ?? "nil")
            print(changeCategory)
            let notesItem = NotesText(context: context)
            
            if secondCategory != changeCategory {
                delegate?.giveSeconCategory(secCategory: changeCategory, index: index)
                notesItem.secondCategory = changeCategory
            }else{
                delegate?.giveSeconCategory(secCategory: "",index: nil)
                notesItem.secondCategory = secondCategory
                
            }
            notesItem.text = userText.text!
            notesItem.category = category
            saveData()
        }
        else if index != nil {
            delegate?.giveSeconCategory(secCategory: "", index: index)
        }
    }

}


//MARK: - Сохранение данных

extension NotebookViewController {
    
    func saveData(){
        do{
            try context.save()
        }catch{
            print("Ошибка сохранения данных - \(error)")
        }
    }
    
    func loadData() {
        

        let request = NSFetchRequest<NotesText>(entityName: "NotesText") /// мы приравниваем request ко всем элементам Notes в сущности Notes
        let predicate = NSPredicate(format: "category == %@", category)
        let secondPredicate = NSPredicate(format: "secondCategory == %@", secondCategory!)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate,secondPredicate])
        request.predicate = compoundPredicate
        
        do{
            let arr =  try context.fetch(request)
            
            if arr.count > 1 {
                userText.text = arr[arr.count - 1].text
                context.delete(arr[0])
                saveData()
            }else if arr.count != 0 {
                userText.text = arr[arr.count - 1].text
            }
            
        }catch{
            print("Ошибка загрузки данных - \(error)")
        }
    }
}

//MARK: - Функци создание заголовка

extension NotebookViewController {
    
    func creatSecondCategory(userText:String) -> String {
        
        if userText == "" {return ""}
        var text = userText.map {String($0)}
        var arr = ""
        var count = 0
        
        for i in 0...text.count - 1 {
            if text[i] == " " && i == 0 {
                text.removeFirst()
                break
            }else if text[i] == " "{
                count = count + 1
                if count < 3 {arr = arr + " "}
            }
            else{
                arr = arr + text[i]
            }
            
            if count == 3 {break}
        }
        
        if count == 3 {
            return arr + "..."
        }else{
            return arr
        }
    }
    
}





