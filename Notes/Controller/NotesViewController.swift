//
//  TableViewController.swift
//  Notes
//
//  Created by Деним Мержан on 16.03.23.
//

import UIKit
import CoreData

class NotesViewController: UITableViewController {
    
    var category = ""
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var notesArray = [NotesCategory]()
    
    override func viewWillAppear(_ animated: Bool) {
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.barStyle = .black
        navigationBar?.backgroundColor = UIColor(named: "NotesBackgound")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
    }
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Добавить заметку", message: "", preferredStyle: .alert)
        
        alert.addTextField { UITextField in
            textField = UITextField
        }
        
        let action = UIAlertAction(title: "Добавить", style: .default) { UIAlertAction in
            print("Hey")
            
            if textField.text != ""{
                let notesItem = NotesCategory(context: self.context)
                print(textField.text ?? "nil")
                notesItem.title = textField.text!
                print("Wow")
                self.notesArray.append(notesItem)
                self.saveData()
            }
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
}
    
    // MARK: - Работа с ячейками
    
    
    extension NotesViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryNotesCell", for: indexPath)
        cell.textLabel?.text = notesArray[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        category = notesArray[indexPath.row].title!
        performSegue(withIdentifier: "goToNotes", sender: self)

        
        tableView.deselectRow(at: indexPath, animated: true)
    }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let destantionVC = segue.destination as! SecondNotesViewController
            destantionVC.category = category
            
        }

}


// MARK: - Сохранение и чтение данных


extension NotesViewController {
    
    func saveData(){
        do {
            try context.save()
        }catch{
            print("Ошибка сохранения данных - \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadData() {
        let request = NSFetchRequest<NotesCategory>(entityName: "NotesCategory")
        do {
           notesArray =  try context.fetch(request)
        }catch{
            print("Ошибка чтения данных - \(error)")
        }
        tableView.reloadData()
    }
    
}



