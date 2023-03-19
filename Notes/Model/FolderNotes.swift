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
    
    let Category = List<Category>()
    
}
