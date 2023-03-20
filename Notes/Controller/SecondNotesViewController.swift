//
//  SecondNotesViewController.swift
//  Notes
//
//  Created by Деним Мержан on 16.03.23.
//

import UIKit
import RealmSwift

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
    

    override func viewDidDisappear(_ animated: Bool) {
        do {try realm.write {
            if categoryArr != nil {
                folder?.count = String(categoryArr!.count)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath)
        cell.textLabel?.text = categoryArr?[indexPath.row].name ?? "Нет заметок"
        cell.detailTextLabel?.text = categoryArr?[indexPath.row].subTitle ?? ""
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
