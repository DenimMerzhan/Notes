//
//  ConvertString.swift
//  Notes
//
//  Created by Деним Мержан on 17.03.23.
//

import Foundation
import RealmSwift


struct ConvertString {
    
    func creatTitle(userText:String) -> String { /// Убираем все кроме 3 или меньше слов в тексте для заголовка
        
        if userText == "" {return ""}
        var text = userText.map {String($0)}
        var arr = ""
        var count = 0
        
        for i in 0...text.count - 1 {
            if text[i] == " " && i == 0 {
                text.removeFirst()
                break
            }else if text[i] == " "{
                count = count + 1
                if count < 3 {arr = arr + " "}
            }
            else{
                arr = arr + text[i]
            }
            
            if count == 3 {break}
        }
        
        
        
        if count == 3 {
            return arr + "..."
        }else{
            return arr
        }
    }
    


func createSubtitle(userText: String) -> String? {
    
    if userText == "" {return ""}
    
    let text = userText.map {String($0)}
    var newText = ""
    var count = 0

    for i in 0...text.count - 1  {
        if count == 1 && text[i] != "\n" {
            newText = newText + text[i]
        }
        if text[i] == "\n" {
            count = count + 1
        }
        if count == 2 {
            break
        }
        
    }
    
    if findProbel(text: newText){
        return nil
    }else{
        return newText
    }
    
}

func findProbel(text: String) -> Bool {
    let newText = text.map {String($0)}
    
    for i in newText {
        if i != " " {
            return false
        }
    }
    return true
}
    
    
}

