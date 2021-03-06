//
//  MyMovieList.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/8/4.
//
import CoreData
import Foundation

class MyMovieList : NSManagedObject{
    @NSManaged var uuid : String
    @NSManaged var original_title : String?
    @NSManaged var title : String?
    @NSManaged var vote_average: Double
    @NSManaged var release_date: String?
    @NSManaged var poster_path : String?
    @NSManaged var overview : String?
    @NSManaged var backdrop_path : String?
    @NSManaged var id : NSInteger
    @NSManaged var addDate: Date
    
    override func awakeFromInsert() {
        self.uuid = UUID().uuidString
        self.addDate = Date()
       // self.date = DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .short) //時間樣式
    }
    //刪除前呼叫
//    override func prepareForDeletion() {
//        if let imagePath = self.imageName {
//            let home = URL(fileURLWithPath: NSHomeDirectory()) //利用URL物件組路徑
//            let doc = home.appendingPathComponent("Documents") //Documents不要拼錯
//            let filePath = doc.appendingPathComponent(imagePath)
//            if FileManager.default.fileExists(atPath: filePath.path) {
//                try? FileManager.default.removeItem(at: filePath)
//            }
//    }
//    }
}
