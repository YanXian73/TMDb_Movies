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
    @NSManaged var id : String
    @NSManaged var title : String?
    @NSManaged var date : String
    @NSManaged var imageName: String?
    @NSManaged var contentText : String?
    
    static func == (lhs: TicketStub, rhs: TicketStub) -> Bool {
        return lhs.id == rhs.id
    }
    func image() -> UIImage? {
        if let imagePath = self.imageName {
            let home = URL(fileURLWithPath: NSHomeDirectory()) //利用URL物件組路徑
            let doc = home.appendingPathComponent("Documents") //Documents不要拼錯
            let filePath = doc.appendingPathComponent("\(imagePath).jpg")
            return UIImage(contentsOfFile: filePath.path)
        }
        return nil
    }
    func thumbnailImage() -> UIImage? {
        let height = floor((UIScreen.main.bounds.height - 3 * 2) / 3)  // 設定每一排3張照片 間距是3，有兩個間距
        let width = floor((UIScreen.main.bounds.width - 3 * 2) / 3)  // 設定每一排3張照片 間距是3，有兩個間距

        if let image = self.image() {
            let thumbnailSize = CGSize(width: width, height: height); //設定縮圖⼤⼩
            let scale = UIScreen.main.scale //找出⽬前螢幕的scale，視網膜技術為2.0
            //產⽣畫布，第⼀個參數指定⼤⼩,第⼆個參數true:不透明（⿊⾊底）,false表⽰透明背景,scale為螢幕scale
            UIGraphicsBeginImageContextWithOptions(thumbnailSize,false,scale)
            //計算長寬要縮圖比例，取最⼤值MAX會變成UIViewContentModeScaleAspectFill
            //最⼩值MIN會變成UIViewContentModeScaleAspectFit
            let widthRatio = thumbnailSize.width / image.size.width;
            let heightRadio = thumbnailSize.height / image.size.height;
            let ratio = max(widthRatio,heightRadio);
            let imageSize = CGSize(width:image.size.width*ratio,height: image.size.height*ratio);
            
            //切圓形
//            let circlePath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: thumbnailSize.width, height: thumbnailSize.height))
//            circlePath.addClip();
            
            image.draw(in:CGRect(x: -(imageSize.width-thumbnailSize.width)/2.0,y:
                                    (imageSize.height-thumbnailSize.height)/2.0,
                                 width: imageSize.width,height: imageSize.height))
            //取得畫布上的縮圖
            let smallImage = UIGraphicsGetImageFromCurrentImageContext();
            //關掉畫布
            UIGraphicsEndImageContext();
            return smallImage
        }else{
            return nil;
    }
}
    
    
    //新增時呼叫
    override func awakeFromInsert() {
        self.id = UUID().uuidString
       // self.date = DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .short) //時間樣式
    }
    //刪除前呼叫
    override func prepareForDeletion() {
        if let imagePath = self.imageName {
            let home = URL(fileURLWithPath: NSHomeDirectory()) //利用URL物件組路徑
            let doc = home.appendingPathComponent("Documents") //Documents不要拼錯
            let filePath = doc.appendingPathComponent(imagePath)
            if FileManager.default.fileExists(atPath: filePath.path) {
                try? FileManager.default.removeItem(at: filePath)
            }
    }
    }
}
