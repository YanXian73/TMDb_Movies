//
//  Remind.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/8/9.
//

import Foundation
import CoreData

class Remind : NSManagedObject {
    @NSManaged  var remind : String?
    @NSManaged var movieName: String?
}
