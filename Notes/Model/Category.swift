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
    
    let notes = List<Notes>
}
