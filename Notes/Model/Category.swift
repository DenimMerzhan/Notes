//
//  Category.swift
//  Notes
//
//  Created by Деним Мержан on 19.03.23.
//

import Foundation
import RealmSwift

class Category: Object {
   @objc dynamic var name: String = "Нет категорий"
   @objc dynamic var subTitle: String?
    
    let notes = List<Notes>()
    var parentCategory = LinkingObjects(fromType: FolderNotes.self, property: "Category")
}
