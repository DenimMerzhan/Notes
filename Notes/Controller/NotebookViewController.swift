//
//  ViewController.swift
//  Notes
//
//  Created by Деним Мержан on 16.03.23.
//

import UIKit
import RealmSwift

class NotebookViewController: UIViewController {
    
    weak var delegate: SecondCategory?
    var folder: FolderNotes?
    var notesArr: Results<Notes>?
    var text = ""
    var category : Category? {
        didSet {
            text = loadData()
        }
    }
    let realm = try! Realm()
    
    let convertString = ConvertString()
    @IBOutlet weak var userText: UITextView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.barStyle = .black
        navigationBar?.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userText.text = text
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        let title =  convertString.creatTitle(userText: userText.text!)
        let subTitle = convertString.createSubtitle(userText: userText.text!)
        
        if let currentFolder = folder {
            

                
                do{
                    
                    try realm.write {
                        
                        let newCategory = Category() /// Создаем новую категорию
                        newCategory.name = title /// устанвливаем ей название
                        if subTitle != nil {
                            newCategory.subTitle = subTitle!
                        }
                        currentFolder.Category.append(newCategory)
                        if category != nil { /// Если категория уже сущестовала
                            realm.delete(notesArr![0]) /// Удаляем текст заметки в категории
                            realm.delete(category!)} /// Удаляем категорию
                        
                        let newNotes = Notes() /// Создаем новую заметку
                        newNotes.text = userText.text ?? "nil"
                        newCategory.notes.append(newNotes) /// Добавляем ее к новой категории
                        
                    }
                }
                
                catch{print("Ошибка добавления заметки - \(error)")}
            }
        
    }
        
}


//MARK: - Сохранение данных

extension NotebookViewController {
    
    func loadData() -> String {
        notesArr = category?.notes.sorted(byKeyPath: "text")
        
        return notesArr![0].text
    }
    
}


