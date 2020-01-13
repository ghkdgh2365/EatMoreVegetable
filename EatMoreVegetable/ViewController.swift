//
//  ViewController.swift
//  EatMoreVegetable
//
//  Created by Ho Hwang on 08/01/2020.
//  Copyright © 2020 hohwang. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let foodItem = foodItems[indexPath.row]
        
        let foodType = foodItem.foodType
        cell.textLabel?.text = foodType
        
        let foodDate = foodItem.added as! Date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d yyyy, hh:mm"
        
        cell.detailTextLabel?.text = dateFormatter.string(from: foodDate)
        
        if foodType == "Fruit" {
          cell.imageView?.image = UIImage(named: "Apple")
        }else{
          cell.imageView?.image = UIImage(named: "Salad")
        }
        
        return cell
        
    }
    

    var foodItems = [Food]()
    var moc:NSManagedObjectContext!
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moc = appDelegate?.persistentContainer.viewContext
        self.tableView.dataSource = self
        
        loadData()
        // Do any additional setup after loading the view.
    }
    
    func loadData(){
        let foodRequest:NSFetchRequest<Food> = Food.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "added", ascending: false)
        foodRequest.sortDescriptors = [sortDescriptor]
        
        do {
            try foodItems = moc.fetch(foodRequest)
        }catch{
            print("Could not load data")
        }
        
        self.tableView.reloadData()
    }

    @IBAction func startReminding(_ sender: Any) {
        appDelegate?.scheduleNotification()
    }
    
    @IBAction func addFoodToDatabase(_ sender: UIButton) {
        let foodItem = Food(context: moc)
        foodItem.added = NSDate() as Date
        
        if sender.tag == 0 {
         foodItem.foodType = "Fruit"
        }else if sender.tag == 1 {
           foodItem.foodType = "Vegetable"
        }
        
        appDelegate?.saveContext()
        
        loadData()
    }
    
    
}

