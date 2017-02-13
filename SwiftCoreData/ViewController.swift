//
//  ViewController.swift
//  SwiftCoreData
//
//  Created by dev on 2/13/17.
//  Copyright © 2017 Skander Jabouzi. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var people = [NSManagedObject]()
    
    struct Person {
        var name: String
        var surname: String
        var age: Double
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\"The List\""
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        let appDelegate =  UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        //2
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        //3
        do {
            let results =  try managedContext.fetch(fetchRequest)
            people = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let person = people[indexPath.row]
        let name = person.value(forKey: "name") as? String
        let surname = person.value(forKey: "surname") as? String
        let age = person.value(forKey: "age") as? Double
        cell!.textLabel!.text = "\(surname!), \(name!) : \(age!)"
        return cell!
    }
    
    //Implement the addName IBAction
    @IBAction func addName(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { (action:UIAlertAction) -> Void in
            
            let person = Person(name: alert.textFields![0].text!, surname: alert.textFields![1].text! ,age: Double(alert.textFields![2].text!)!)
            self.saveName(person)
            self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextField {
            (textField: UITextField) -> Void in
        }
        alert.addTextField {
            (textField: UITextField) -> Void in
        }
        alert.addTextField {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert,
                animated: true,
                completion: nil)
    }
    
    func saveName(_ data: Person) {
        //1
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        //2
        let entity =  NSEntityDescription.entity(forEntityName: "Person", in:managedContext)
        
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        //3
        
        person.setValue(Double(data.age), forKey: "age")
        person.setValue(data.name, forKey: "name")
        person.setValue(data.surname, forKey: "surname")
        
        
        //4
        do {
            try managedContext.save()
            //5
            people.append(person)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
}
