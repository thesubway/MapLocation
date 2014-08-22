//
//  RemindersViewController.swift
//  MapLocation
//
//  Created by Dan Hoang on 8/21/14.
//  Copyright (c) 2014 Dan Hoang. All rights reserved.
//

import UIKit
import CoreData

class RemindersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    var reminders = [Reminder]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController!) {
        self.tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController!, didChangeObject anObject: AnyObject!, atIndexPath indexPath: NSIndexPath!, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath!) {
        switch type {
        case .Insert:
            self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//        case .Update:
//            self.configureCell(self.tableView.cellForRowAtIndexPath(indexPath), forIndexPath: indexPath)
        case .Move:
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
        default:
            println()
        }
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
    }
    
    func tableView(tableView: UITableView!, editActionsForRowAtIndexPath indexPath: NSIndexPath!) -> [AnyObject]! {
        // create a delete action
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete") {
            (action, indexPath) in
            // implement the delete changes
        }
        
        let moreAction = UITableViewRowAction(style: .Default, title: "Edit") { (action, indexPath) -> Void in
            println("Go to edit page")
        }
        
        // set the background color for the action button
        deleteAction.backgroundColor = UIColor.redColor()
        moreAction.backgroundColor = UIColor.lightGrayColor()
        
        // return an array of actions
        return [deleteAction, moreAction]
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("reminderCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel.text = reminders[indexPath.row].message
        return cell
    }

}
