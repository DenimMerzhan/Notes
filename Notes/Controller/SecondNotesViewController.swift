//
//  SecondNotesViewController.swift
//  Notes
//
//  Created by Деним Мержан on 16.03.23.
//

import UIKit
import CoreData

class SecondNotesViewController: UITableViewController, SecondCategory {
    
    var secondCategory: String? /// Вторая категория по которой мы определяем отображаемый текст в заметке
    var subTitle: String?
    var changes: Bool?
    var index: Int? /// Индекс текущего элемента SecondNotes
    var category = String() /// Главная категория папок заметок
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext /// Создаем ссылку на контекст  внутри Apple Delegate
    var notesArray = [SecondNotes]()
    
    func giveSeconCategory(secCategory: String,subTitle: String, index: Int?, changes: Bool) { /// Функция которая нам возваращает заголовок и индекс элемента из NotebookViewController
        secondCategory = secCategory
        self.subTitle = subTitle
        print(index ?? "нииил")
        self.index = index
        self.changes = changes
    }

    override func viewWillAppear(_ animated: Bool) { /// Настраиваем NavigationBar
        
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.barStyle = .black
        navigationBar?.backgroundColor = UIColor(named: "NotesBackgound")
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        

        if changes != nil {
            print("Yeahdwd")
            print(changes!)
            if changes! { /// Если заголовок, переданный NotebookVC, не пустой
                
                if index != nil { /// Если была существущая ячейка с индексом и у нее изменился заголовок то мы удаляем старую ячейку со старым заголовком
                    context.delete(notesArray[index!])
                    notesArray.remove(at: index!)
                    saveData()
                }
                
                let item = SecondNotes(context: context) /// Создаем новый элемент класса SecondNotes в том случае если заголовок изменился и не равен пустой строке
                item.title = secondCategory /// Данный заголовок мы получили из текста заметки см функция giveSeconCategory
                item.subTitile = subTitle
                item.category = category
                notesArray.append(item)
                saveData()
            }
            
            else if index != nil { /// Если текст в заметке = пустой строке и это была существующая ячейка, то мы удаляем ячейку
                    print("Yeah")
                    context.delete(notesArray[index!])
                    notesArray.remove(at: index!)
                    saveData()
            }
        }
    }
    

    

    
    @IBAction func addButtonPressed(_ sender: Any) { /// Если кнопка нажата то переходим в заметку
        secondCategory = nil /// вторая категория фильтрации ничему не равна, т.к мы первый раз заходим в заметку
        index = nil /// Аналогично
        subTitle = nil
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
        cell.detailTextLabel?.text = notesArray[indexPath.row].subTitile
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        secondCategory = notesArray[indexPath.row].title!
        category = notesArray[indexPath.row].category!
        index = indexPath.row
        subTitle = notesArray[indexPath.row].subTitile
        performSegue(withIdentifier: "goToText", sender: self)

        
        tableView.deselectRow(at: indexPath, animated: true)
    }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            let destantionVC = segue.destination as! NotebookViewController
            destantionVC.category = category /// Передаем главную категорию папок заметок
            destantionVC.secondCategory = secondCategory /// Передаем вторую категорию
            destantionVC.index = index /// Передаем индекс текущего выбранного элемента
            destantionVC.mainSubtitle = subTitle
            destantionVC.delegate = self /// Назначаем себя делегатом
            
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
        
        let request = NSFetchRequest<SecondNotes>(entityName: "SecondNotes") /// Берем все элементы которые имееют тип SeconNotes
        let predicate = NSPredicate(format: "category == %@", category) /// Создаем условие по главной категории
        request.predicate = predicate /// Добавляем условие
        
        do {
           notesArray =  try context.fetch(request)
        }catch{
            print("Ошибка чтения данных - \(error)")
        }
        tableView.reloadData()
    }
    
}
