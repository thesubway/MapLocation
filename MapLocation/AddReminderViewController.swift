//
//  AddReminderViewController.swift
//  MapLocation
//
//  Created by Dan Hoang on 8/21/14.
//  Copyright (c) 2014 Dan Hoang. All rights reserved.
//

import UIKit
import CoreData

class AddReminderViewController: UIViewController {

    @IBOutlet var latitudeBox: UITextField!
    
    @IBOutlet var longitudeBox: UITextField!
    @IBOutlet var messageBox: UITextField!
    
    var myContext : NSManagedObjectContext!
    override func viewDidLoad() {
        super.viewDidLoad()

        var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.myContext = appDelegate.managedObjectContext
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func savePressed(sender: AnyObject) {
        let remindersVC = self.storyboard.instantiateViewControllerWithIdentifier("remindersVC") as RemindersViewController
        var reminder = NSEntityDescription.insertNewObjectForEntityForName("Reminder", inManagedObjectContext: self.myContext) as Reminder
//        reminder.latitude = latitudeBox.text.toInt()!
//        reminder.longitude = longitudeBox.text
        reminder.message = messageBox.text
        remindersVC.reminders.append(reminder)
        self.navigationController.pushViewController(remindersVC, animated: true)
    }
    

}
