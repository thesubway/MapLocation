//
//  Reminder.swift
//  MapLocation
//
//  Created by Dan Hoang on 8/20/14.
//  Copyright (c) 2014 Dan Hoang. All rights reserved.
//

import Foundation
import CoreData

class Reminder: NSManagedObject {

    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var message: String

}
