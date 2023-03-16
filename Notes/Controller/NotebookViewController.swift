//
//  ViewController.swift
//  Notes
//
//  Created by Деним Мержан on 16.03.23.
//

import UIKit
import CoreData

class NotebookViewController: UIViewController {

    var category = String()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var userText: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(category)
        loadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let notesItem = NotesText(context: context)
        notesItem.text = userText.text!
        notesItem.category = category
        print(category)
        saveData()
    }

}


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
        request.predicate = predicate
        do{
            let arr =  try context.fetch(request)
            
            if arr.count > 1 {
                userText.text = arr[arr.count - 1].text
                context.delete(arr[0])
                saveData()
                print(arr.count)
            }else if arr.count != 0 {
                userText.text = arr[arr.count - 1].text
            }
            
        }catch{
            print("Ошибка загрузки данных - \(error)")
        }
    }
}





