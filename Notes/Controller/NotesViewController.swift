//
//  TableViewController.swift
//  Notes
//
//  Created by Деним Мержан on 16.03.23.
//

import UIKit
import RealmSwift
import SwipeCellKit

class NotesViewController: UITableViewController {
    
    var folderArray: Results<FolderNotes>?
    let realm = try! Realm()
    
    override func viewWillAppear(_ animated: Bool) { /// Устанавливаем Navigation bar под нужные параметры и цвет
        
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.barStyle = .black
        navigationBar?.backgroundColor = UIColor(named: "NotesBackgound")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        loadData() /// Загружаем данные
        
    }
    
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {  /// Создаем оповещение
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Добавить заметку", message: "", preferredStyle: .alert)
        
        alert.addTextField { UITextField in
            textField = UITextField
        }
        
        let action = UIAlertAction(title: "Добавить", style: .default) { UIAlertAction in
            
            if textField.text != "" {
                

                let newFolder = FolderNotes()
                newFolder.name = textField.text!
                self.saveData(item: newFolder)
            }
        }
        
        alert.addAction(action) /// Добавляем действие
        present(alert, animated: true)  /// Презентуем действие
    }
    
}
    
    // MARK: - Работа с ячейками
    
    
    extension NotesViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return folderArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryNotesCell", for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = folderArray?[indexPath.row].name ?? "Нет папок" /// Указываем текст ячейки
        cell.detailTextLabel?.text = folderArray?[indexPath.row].count ?? "0"
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { /// Если пользователь выбрал ячейку
        performSegue(withIdentifier: "goToNotes", sender: self)

        tableView.deselectRow(at: indexPath, animated: true)
    }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let destantionVC = segue.destination as! SecondNotesViewController
            if let index = tableView.indexPathForSelectedRow {
                destantionVC.folder =  folderArray![index.row]
            }
            
        }

}


// MARK: - Сохранение и чтение данных


extension NotesViewController {
    
    func saveData(item: FolderNotes){
        
        do {
            try realm.write({
                realm.add(item)
            })
        }catch{
            print("Ошибка сохранения данных - \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadData() {
        
        folderArray = realm.objects(FolderNotes.self) /// Все объекты Folders
        
        tableView.reloadData()
    }
    
}


//MARK: - Работа со свайпами

extension NotesViewController : SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        
        guard orientation == .right else { return nil }

           let deleteAction = SwipeAction(style: .destructive, title: "delete") { action, indexPath in
               
               if let deleteFolder = self.folderArray?[indexPath.row] {
                   
                   let categoryArr = deleteFolder.Category.sorted(byKeyPath: "name")
                   
                   try! self.realm.write {
                       for i in categoryArr {
                           self.realm.delete(i.notes) /// Удаляем заметки в каждой категории
                       }
                       
                       self.realm.delete(deleteFolder.Category) /// Удаляем категорию
                       self.realm.delete(deleteFolder) /// Удаляем папку
                   }
               }
               
           }


           deleteAction.image = UIImage(named: "delete")

           return [deleteAction]
        
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }

    
    
}



