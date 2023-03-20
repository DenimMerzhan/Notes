//
//  SecondNotesViewController.swift
//  Notes
//
//  Created by Деним Мержан on 16.03.23.
//

import UIKit
import RealmSwift
import SwipeCellKit

class SecondNotesViewController: UITableViewController {
    
    var secondCategory: String? /// Вторая категория по которой мы определяем отображаемый текст в заметке
    var categoryArr: Results<Category>?
    var folder:  FolderNotes? {
        didSet {
            loadData()
        }
    }
    let realm = try! Realm()
    
    override func viewWillAppear(_ animated: Bool) { /// Настраиваем NavigationBar
        
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.barStyle = .black
        navigationBar?.backgroundColor = UIColor(named: "NotesBackgound")
//        loadData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if folder != nil { /// Когда мы возвращаемся с заметки нужно обновить данные что бы показалась новая папка
            loadData()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        do {try realm.write {
            if categoryArr != nil {
                folder?.count = String(categoryArr!.count) /// Устанавливаем количество папок в папке
                print("fuck")
            }
        }
        }catch{}
    }
    
    
    
    @IBAction func addButtonPressed(_ sender: Any) { /// Если кнопка нажата то переходим в заметку
        performSegue(withIdentifier: "goToText", sender: self)
        
    }
    
}




    // MARK: - Table view data source

    extension SecondNotesViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryArr?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = categoryArr?[indexPath.row].name ?? "Нет заметок"
        cell.detailTextLabel?.text = categoryArr?[indexPath.row].subTitle ?? ""
        cell.delegate = self
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToText", sender: self)


        tableView.deselectRow(at: indexPath, animated: true)
    }

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

            let destanationVC = segue.destination as! NotebookViewController
                destanationVC.folder = folder
            if let index = tableView.indexPathForSelectedRow {
                destanationVC.category = categoryArr![index.row]
            }

        }

}






// MARK: - Сохранение и чтение данных


extension SecondNotesViewController {


    func loadData() {
        
        categoryArr = folder?.Category.sorted(byKeyPath: "name",ascending: true) /// Все объекты category  c текущим folders

        tableView.reloadData()
    }

}

//MARK: - Работа со свайпами

extension SecondNotesViewController : SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        
        guard orientation == .right else { return nil }

           let deleteAction = SwipeAction(style: .destructive, title: "delete") { action, indexPath in
               
               if let deleteCategory = self.categoryArr?[indexPath.row] {
                   
                   try! self.realm.write({
                       self.realm.delete(deleteCategory.notes)
                       self.realm.delete(deleteCategory)
                   })
                   
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
