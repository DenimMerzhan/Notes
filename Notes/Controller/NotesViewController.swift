//
//  TableViewController.swift
//  Notes
//
//  Created by Деним Мержан on 16.03.23.
//

import UIKit
import CoreData

class NotesViewController: UITableViewController {
    
    var category = "" /// Первичная категория по которой мы фильтруем заметки
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var notesArray = [NotesCategory]()
    
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
                
                let notesItem = NotesCategory(context: self.context)  /// Создаем переменную класса NotesCategory
                notesItem.title = textField.text! /// Присваиваем значение заголовка
                self.notesArray.append(notesItem) /// Добавляем в массив
                self.saveData() /// Сохраняем контекст
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
        return notesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryNotesCell", for: indexPath) /// Подключаемся к нашей ячейке в Main
        cell.textLabel?.text = notesArray[indexPath.row].title /// Указываем текст ячейки
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { /// Если пользователь выбрал ячейку
        category = notesArray[indexPath.row].title!
        performSegue(withIdentifier: "goToNotes", sender: self)

        tableView.deselectRow(at: indexPath, animated: true)
    }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let destantionVC = segue.destination as! SecondNotesViewController
            destantionVC.category = category /// Передаем главную категорию по которой отображаем заметки
            
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



