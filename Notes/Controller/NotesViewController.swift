//
//  TableViewController.swift
//  Notes
//
//  Created by Деним Мержан on 16.03.23.
//

import UIKit
import RealmSwift

class NotesViewController: UITableViewController {
    
    var folderArray: Results<FolderNotes>?
    let realm = try! Realm()
    
    override func viewWillAppear(_ animated: Bool) { /// Устанавливаем Navigation bar под нужные параметры и цвет
        
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.barStyle = .black
        navigationBar?.backgroundColor = UIColor(named: "NotesBackgound")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryNotesCell", for: indexPath) /// Подключаемся к нашей ячейке в Main
        cell.textLabel?.text = folderArray?[indexPath.row].name ?? "Нет папок" /// Указываем текст ячейки
        cell.detailTextLabel?.text = folderArray?[indexPath.row].count ?? "0"
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



