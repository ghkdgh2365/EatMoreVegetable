//
//  ViewController.swift
//  EatMoreVegetable
//
//  Created by Ho Hwang on 08/01/2020.
//  Copyright © 2020 hohwang. All rights reserved.
//

import UIKit
import CoreData
import Foundation


class ViewController: UIViewController, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var timeArray = ["1", "2", "3", "4", "6", "8", "12", "61"]
    var selectRow = 0
    @IBOutlet weak var alarmPeriod: UIPickerView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return timeArray[row]
        }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectRow = row
    }
    
    
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
        cell.textLabel?.text = "기도했어요"
        
        let foodDate = foodItem.added as! Date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d yyyy, hh:mm"
        
        cell.detailTextLabel?.text = dateFormatter.string(from: foodDate)
        
        if foodType == "Fruit" {
          cell.imageView?.image = UIImage(named: "pray")
        }else{
          cell.imageView?.image = UIImage(named: "pray")
        }
        
        return cell
        
    }
    

    var foodItems = [Food]()
    var moc:NSManagedObjectContext!
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var setPeriod: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPeriod.layer.cornerRadius = 10
        
        self.alarmPeriod.delegate = self
        self.alarmPeriod.dataSource = self
        
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
        appDelegate?.scheduleNotification(timeArray[selectRow])
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

