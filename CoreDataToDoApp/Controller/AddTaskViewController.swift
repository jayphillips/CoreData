//
//  AddTaskViewController.swift
//  CoreDataToDoApp
//
//  Created by Jay Phillips on 1/1/19.
//  Copyright © 2019 Jay Phillips. All rights reserved.
//

import UIKit
import CoreData

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var taskTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func saveTask(completion: (_ finished: Bool) -> ()) {
        guard let context = appDelegate?.persistentContainer.viewContext else { return }
        let newTask = Tasks(context: context)
        newTask.taskDescription = taskTextView.text
        newTask.taskStatus = false
        
        do {
            try context.save()
            print("The task was saved.")
            completion(true)
        } catch {
            print("\(error.localizedDescription)")
            completion(false)
        }
        
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        saveTask { (completed) in
            if completed {
                print("Data successfully saved.")
                navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            } else {
                print("Data was not saved.")
            }
        }
    }
}
