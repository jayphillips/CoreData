//
//  TasksViewController.swift
//  CoreDataToDoApp
//
//  Created by Jay Phillips on 12/30/18.
//  Copyright © 2018 Jay Phillips. All rights reserved.
//

import UIKit
import CoreData

class TasksViewController: UIViewController {
    
    // IBOutlets
    @IBOutlet weak var tasksTableView: UITableView!

    
    
    // Variables
    var tasks = [Tasks]()
    
    // Constants
    let taskCell = "taskCell"
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        
       }
    
    override func viewWillAppear(_ animated: Bool) {
        getTasks()
        tasksTableView.reloadData()
    }
    
    // Functions
    
    func setDelegates() {
        tasksTableView.dataSource = self
        tasksTableView.delegate = self
    }
    
    func getTasks() {
        getTask { (success) in
            if success {
                if tasks.count > 0 {
                    tasksTableView.isHidden = false
                } else {
                    tasksTableView.isHidden = true
                }
                print("Data has been fetched successfully.")
            } else {
                print("Data cannot be retrieved.")
            }
        }
    }
    
    
    // IBActions


}

extension TasksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: taskCell, for: indexPath) as! TaskCell
        let task = tasks[indexPath.row]
        cell.taskLabel.text = task.taskDescription
        if task.taskStatus == true {
            cell.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            cell.taskLabel.text = "Completed"
            cell.taskLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.deleteTask(indexPath: indexPath)
            self.getTasks()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let taskStatus = UITableViewRowAction(style: .normal, title: "Completed") { (action, indexPath) in
            self.updateTaskStatus(indexPath: indexPath)
            self.getTasks()
            self.tasksTableView.reloadRows(at: [indexPath], with: .automatic)
        }
        delete.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        taskStatus.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        
        return [delete, taskStatus]
    }
    
}

extension TasksViewController {
    func getTask(completion: (_ complete: Bool) -> ()) {
        guard let context = appDelegate?.persistentContainer.viewContext else { return }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tasks")
        
        do {
            tasks = try context.fetch(request) as! [Tasks]
            print("Data was fetched successfully.")
            completion(true)
        } catch {
            print("\(error.localizedDescription)")
            completion(false)
        }
        
    }
    
    func deleteTask(indexPath: IndexPath) {
        guard let context = appDelegate?.persistentContainer.viewContext else { return }
        context.delete(tasks[indexPath.row])
        do {
            try context.save()
            print("Data was deleted.")
            } catch {
                print("Could not delete data.")
        }
    }
    
    func updateTaskStatus(indexPath: IndexPath) {
        guard let context = appDelegate?.persistentContainer.viewContext else { return }
        let task = tasks[indexPath.row]
        if task.taskStatus == true {
            task.taskStatus = false
        } else {
            task.taskStatus = true
        }
        do {
            try context.save()
            print("The task was successfully updated.")
        } catch {
            print("Could not update the task's status: \(error.localizedDescription)")
        }
    }
}
