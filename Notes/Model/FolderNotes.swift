//
//  FolderNotes.swift
//  Notes
//
//  Created by Деним Мержан on 19.03.23.
//

import Foundation
import RealmSwift

class FolderNotes: Object {
   @objc dynamic var name: String = "Нет папок"
   @objc dynamic var count: String = "0"
    
    let Category = List<Category>()
    
}
