//
//  AppDelegate.swift
//  EatMoreVegetable
//
//  Created by Ho Hwang on 08/01/2020.
//  Copyright © 2020 hohwang. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (authorized:Bool, error:Error?) in
            if !authorized {
                print("App is useless because you did not allow notification.")
            }
        }
        
        // Define Actions
        let fruitAction = UNNotificationAction(identifier: "addFruit", title: "Add a piece of fruit", options: [])
        let vegiAction = UNNotificationAction(identifier: "addVegetable", title: "Add a piece of Vegetable", options: [])
        
        // Add actions to a foodCategory
        let category = UNNotificationCategory(identifier: "foodCategory", actions: [fruitAction, vegiAction], intentIdentifiers: [], options: [])
        
        // Add the foodCategory to Notification Framework
        UNUserNotificationCenter.current().setNotificationCategories([category])
        

        return true
    }
    
    func scheduleNotification(_ period:String) {
        let period = Double(period) ?? 1.0

        UNUserNotificationCenter.current().delegate = self
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: period, repeats: true)
        let content = UNMutableNotificationContent()
        content.title = "지금도 주님은 나와 함께 계셔요"
        content.body = "항상 기뻐하라 쉬지 말고 기도하라 범사에 감사하라 이는 그리스도 예수 안에서 너희를 향하신 하나님의 뜻이니라(딤전 5:16-18)"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "foodCategory"
        
        guard let path = Bundle.main.path(forResource: "pray", ofType: "png") else {return}
        let url = URL(fileURLWithPath: path)
        
        do {
            let attachment = try UNNotificationAttachment(identifier: "logo", url: url, options: nil)
            content.attachments = [attachment]
        }catch{
            print("The attachment could not be loaded.")
        }
        
        let request = UNNotificationRequest(identifier: "foodNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) { (error:Error?) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            
        }
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void){
        
        let foodItem = Food(context: persistentContainer.viewContext)
        foodItem.added = NSDate() as Date
        
        if response.actionIdentifier == "addFruit" {
            foodItem.foodType = "Fruit"
        }else { //vegetable
            foodItem.foodType = "Vegetable"
        }
        
        self.saveContext()
        completionHandler()
    }
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "EatMoreVegetable")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

