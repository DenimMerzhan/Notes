//
//  SecondNotesViewController.swift
//  Notes
//
//  Created by Деним Мержан on 16.03.23.
//

import UIKit
import CoreData

class SecondNotesViewController: UITableViewController {
    
    var category = String()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var notesArray = [SecondNotes]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
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
        category = notesArray[indexPath.row].title!
        performSegue(withIdentifier: "goToNotes", sender: self)

        
        tableView.deselectRow(at: indexPath, animated: true)
    }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let destantionVC = segue.destination as! NotebookViewController
            destantionVC.category = category
            
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
        do {
           notesArray =  try context.fetch(request)
        }catch{
            print("Ошибка чтения данных - \(error)")
        }
        tableView.reloadData()
    }
    
}
