//
//  SecondNotesViewController.swift
//  Notes
//
//  Created by Деним Мержан on 16.03.23.
//

import UIKit
import CoreData

class SecondNotesViewController: UITableViewController, SecondCategory {
    
    var secondCategory: String?
    var changeCategory = ""
    var index: Int?
    var category = String()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var notesArray = [SecondNotes]()
    
    func giveSeconCategory(secCategory: String, index: Int?) {
        if secCategory != "" {
            changeCategory = secCategory
        }
        self.index = index
    }

    override func viewDidAppear(_ animated: Bool) {
        
        loadData()
        
        if changeCategory != "" {
            
            if index != nil {
                context.delete(notesArray[index!])
                notesArray.remove(at: index!)
                saveData()
            }
            
            print(changeCategory)
            let item = SecondNotes(context: context)
            item.title = changeCategory
            item.category = category
            notesArray.append(item)
            saveData()
            changeCategory = ""
        }
        
        else if index != nil {
            
            if index != nil {
                context.delete(notesArray[index!])
                notesArray.remove(at: index!)
                saveData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    
    @IBAction func addButtonPressed(_ sender: Any) {
        secondCategory = nil
        index = nil
        performSegue(withIdentifier: "goToText", sender: self)
    }
    
}

    // MARK: - Table view data source

    extension SecondNotesViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath)
        cell.textLabel?.text = notesArray[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        secondCategory = notesArray[indexPath.row].title!
        category = notesArray[indexPath.row].category!
        index = indexPath.row
        performSegue(withIdentifier: "goToText", sender: self)

        
        tableView.deselectRow(at: indexPath, animated: true)
    }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            let destantionVC = segue.destination as! NotebookViewController
            destantionVC.category = category
            destantionVC.secondCategory = secondCategory
            destantionVC.index = index
            print(index ?? "nil")
            destantionVC.delegate = self
            
        }

}


// MARK: - Сохранение и чтение данных


extension SecondNotesViewController {
    
    func saveData(){
        do {
            try context.save()
        }catch{
            print("Ошибка сохранения данных - \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadData() {
        
        let request = NSFetchRequest<SecondNotes>(entityName: "SecondNotes")
        let predicate = NSPredicate(format: "category == %@", category)
        request.predicate = predicate
        
        do {
           notesArray =  try context.fetch(request)
        }catch{
            print("Ошибка чтения данных - \(error)")
        }
        tableView.reloadData()
    }
    
}
