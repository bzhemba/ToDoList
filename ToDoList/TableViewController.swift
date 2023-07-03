//
//  TableViewController.swift
//  ToDoList
//
//  Created by мария баженова on 03.07.2023.
//

import UIKit
import SwiftUI

class TableViewController: UITableViewController{

    @IBAction func pushAddAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Create new item", message: nil, preferredStyle: .alert)
        alertController.addTextField(){(textField) in textField.placeholder = "New Item Name"}

        let alertAction1 = UIAlertAction(title: "Cancel", style: .destructive){
            (alert) in
        }
        let alertAction2 = UIAlertAction(title: "Create", style: .default){
            (alert) in
            let newItem = alertController.textFields![0].text
            if newItem != ""{
                addItem(nameItem: newItem!)
            }
            self.tableView.reloadData()
        }
       
        alertController.addAction(alertAction1)
        alertController.addAction(alertAction2)
        present(alertController, animated: true, completion: nil)
            
        }
    
    @IBAction func pushEditAction(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let pushNotificationsButton = UIButton(frame: CGRect(x: 75, y: 1, width:20, height: 20))
//        pushNotificationsButton.setImage(UIImage(systemName: "bell.badge"), for: .normal)
//        self.viw.addSubview(pushNotificationsButton )
        
        tableView.tableFooterView = UIView()
//        tableView.backgroundColor = UIColor.systemPink

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ToDoList.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let currentItem = ToDoList[indexPath.row]
        cell.textLabel?.text = currentItem["Name"] as? String
        if (currentItem["isCompleted"] as? Bool) == true{
            cell.imageView?.image = UIImage(named: "check.png")
        }
        else{
            cell.imageView?.image = UIImage(named: "cross.png")
        }
        if tableView.isEditing{
            cell.textLabel?.alpha = 0.4
            cell.imageView?.alpha = 0.4
        }
        else{
            cell.textLabel?.alpha = 1
            cell.imageView?.alpha = 1
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (changeState(at: indexPath.row)) == true{
            tableView.cellForRow(at: indexPath)?.imageView?.image = UIImage(named: "check.png")
        }
        else{
            tableView.cellForRow(at: indexPath)?.imageView?.image = UIImage(named: "cross.png")
        }
        
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeItem(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            
        }
    }


    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        moveItem(fromIndex: fromIndexPath.row, toIndex: to.row)
        
        tableView.reloadData()

    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing{
            return .none
        }
        else{
            return .delete
        }
    }
    
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    private weak var pushNotificationsButton: UIButton!
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        guard self.pushNotificationsButton == nil, let window = tableView.window else {
            return
        }
        let pushNotificationsButton = UIButton(frame: CGRect(x:70, y:58, width:20, height: 20))
        pushNotificationsButton.setImage(UIImage(systemName: "bell.badge"), for: .normal)
        window.addSubview(pushNotificationsButton)
        self.pushNotificationsButton = pushNotificationsButton
        pushNotificationsButton.addTarget(self, action: #selector(requestForNotification), for: .touchUpInside)
    }
    
    @objc func requestForNotification(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge]){
            (isEnabled, error) in

            guard isEnabled else {
                self.pushNotificationsButton.isHidden = true
                return}
            getNotificationSettings()
            self.pushNotificationsButton.isHidden = true
        }
    }
    
//    @IBAction func hide(sender: AnyObject) {
//        UNUserNotificationCenter.current().requestAuthorization(options: [.badge]){
//            (isEnabled, error) in
//
//            guard isEnabled else {
//                return}
//            getNotificationSettings()
//            self.button.isEnabled = true
//        }
//    }
    
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pushNotificationsButton?.removeFromSuperview()
    }

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
