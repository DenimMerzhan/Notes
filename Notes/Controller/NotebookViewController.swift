//
//  ViewController.swift
//  Notes
//
//  Created by Деним Мержан on 16.03.23.
//

import UIKit
import CoreData

class NotebookViewController: UIViewController {
    
    weak var delegate: SecondCategory?
    var mainSubtitle: String?
    var category = String() /// Первичная категория по которой мы фильтруем заметки и текст внутри заметок
    var secondCategory: String? /// Вторая категория фильтрации
    
    let convertString = ConvertString()
    var index: Int? /// Индекс выбраной строки из SecondVC
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var userText: UITextView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.barStyle = .black
        navigationBar?.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if secondCategory != nil{ /// Если это не новая заметка то фильтруем данные для отображения текста в текущей заметке
            loadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        if userText.text != "" && userText.text != nil {
            let changeCategory =  convertString.creatSecondCategory(userText: userText.text!) /// Берем только первые три или меньше слова из всего текста для заголовка
            let subTitle = convertString.createSubtitle(userText: userText.text!)
            let notesItem = NotesText(context: context)
            
            if secondCategory != changeCategory || subTitle != mainSubtitle { /// Если текущий заголовок заметки отличается от нового то передаем текущий заголовок и индекс для удаления старой заметки
                delegate?.giveSeconCategory(secCategory: changeCategory, subTitle: subTitle, index: index, changes: true)
                notesItem.secondCategory = changeCategory
            }else {
                delegate?.giveSeconCategory(secCategory: "", subTitle: "", index: nil, changes: false)
                notesItem.secondCategory = secondCategory
            }
            
            notesItem.text = userText.text! /// Добавляем текст в заметку
            notesItem.category = category /// Устанавливаем главную категорию папок заметок
            saveData()
        }
        
        else if index != nil { /// Если текст поля пуст или nill и это существующая заметка то передаем ее индекс для удаления
            print(index ?? "nillos")
            print("fuck")
            delegate?.giveSeconCategory(secCategory: "", subTitle: "", index: index, changes: false)
        }
    }

}


//MARK: - Сохранение данных

extension NotebookViewController {
    
    func saveData(){
        do{
            try context.save()
        }catch{
            print("Ошибка сохранения данных - \(error)")
        }
    }
    
    func loadData() {
        

        let request = NSFetchRequest<NotesText>(entityName: "NotesText") /// ищем все элементы NotesText
        let predicate = NSPredicate(format: "category == %@", category) /// Добавляем первую категории для фильтра
        let secondPredicate = NSPredicate(format: "secondCategory == %@", secondCategory!) ///  Добавляем вторую категорию
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate,secondPredicate])
        request.predicate = compoundPredicate
        
        do{
            let arr =  try context.fetch(request) /// Получаем массив со строками в котором каждый раз если строка изменилась и пользователь вышел с заметки то она сохраняется как новая
            
            if arr.count > 1 { /// Если элементов строк больше 1 то мы удаляем все кроме последнего элемента что бы не заполнять память
                userText.text = arr[arr.count - 1].text
                context.delete(arr[0])
                saveData()
            }else if arr.count != 0 {
                userText.text = arr[arr.count - 1].text
            }
            
        }catch{
            print("Ошибка загрузки данных - \(error)")
        }
    }
}


