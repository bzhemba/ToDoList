//
//  Model.swift
//  ToDoList
//
//  Created by мария баженова on 03.07.2023.
//

import Foundation
import UserNotifications
import UIKit

//struct TodoItem{
//    let text: String
//    enum Importance{
//        case urgently
//        case manage
//        case delay
//    }
//    let importance: Importance
//    let deadline: Date?
//    let isCompleted: Bool
//    init(text:String = "", deadline: Date? = nil, importance: Importance, isCompleted: Bool = false){
//        self.text = text
//        self.deadline = deadline
//        self.importance = importance
//        self.isCompleted = isCompleted
//    }
//
//}

var ToDoList:[[String:Any]]{
    set{
        UserDefaults.standard.set(newValue, forKey: "ToDataKey")
        UserDefaults.standard.synchronize()
    }
    get{
        if let array = UserDefaults.standard.array(forKey: "ToDataKey") as? [[String:Any]]{
            return array
        }
        else{
            return[]
        }
    }
}

func addItem (nameItem: String, isCompleted: Bool = false){
    ToDoList.append(["Name" : nameItem, "isCompleted": false])
    setBadge()
}

func removeItem(at index: Int){
    ToDoList.remove(at: index)
    setBadge()

}
func changeState(at item: Int) -> Bool{
    ToDoList[item]["isCompleted"] = !(ToDoList[item]["isCompleted"] as! Bool)
    setBadge()
    return ToDoList[item]["isCompleted"] as! Bool
    
}

func saveData(){
    UserDefaults.standard.set(ToDoList, forKey: "ToDataKey")
    
}

func moveItem(fromIndex: Int, toIndex: Int){
    let from = ToDoList[fromIndex]
    ToDoList.remove(at:fromIndex)
    ToDoList.insert(from, at: toIndex)
}

func getNotificationSettings() {
  UNUserNotificationCenter.current().getNotificationSettings { (settings) in
    print("Notification settings: \(settings)")
  }
}

func setBadge(){
    var totalBadgeNumber = 0
            for list in ToDoList {
                if (list["isCompleted"] as? Bool == false){
                    totalBadgeNumber += 1
                }
            }
            UIApplication.shared.applicationIconBadgeNumber = totalBadgeNumber
        }

    //добавить структуру с дедлайном и тд
