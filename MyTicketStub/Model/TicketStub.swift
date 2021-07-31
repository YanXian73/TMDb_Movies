//
//  PickerData.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/7/20.
//
import UIKit
import Foundation
import CoreData

class TicketStub : NSManagedObject {
    
    @NSManaged var title : String?
    @NSManaged var date : String
    @NSManaged var imageName: String?
    @NSManaged var text : String?
    
    
    func image() -> UIImage? {
        if let imagePath = self.imageName {
            let home = URL(fileURLWithPath: NSHomeDirectory()) //利用URL物件組路徑
            let doc = home.appendingPathComponent("Documents") //Documents不要拼錯
            let filePath = doc.appendingPathComponent("\(imagePath).jpg")
            return UIImage(contentsOfFile: filePath.path)
        }
        return nil
    }
    //新增時呼叫
    override func awakeFromInsert() {
        self.date = "\(Date())"
    }
}
