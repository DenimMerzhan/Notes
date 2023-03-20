//
//  Notes.swift
//  Notes
//
//  Created by Деним Мержан on 19.03.23.
//

import Foundation
import RealmSwift

class Notes: Object {
    @objc dynamic var text: String = ""
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "notes")
}
