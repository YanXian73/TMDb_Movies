//
//  ImageOpreation.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/7/28.
//
import UIKit
import Foundation

class ImageOperation : Operation {
    var url : URL
    var indexPath: IndexPath
    var tableView: UITableView
    
    
    init(url: URL, indexPath: IndexPath, tableView: UITableView) {
        self.url = url
        self.indexPath = indexPath
        self.tableView = tableView
        super.init()
        
    }
    override func main() {
        if  let imageData = try? Data(contentsOf: self.url),
            let imageView = UIImage(data: imageData) {
            DispatchQueue.main.async {
                //下載完照片，如果原本的Cell的位置還在畫面上，才更新畫面
                if let originCell = self.tableView.cellForRow(at: self.indexPath) as? MoviesTableViewCell {
                    originCell.movieImageView.image = imageView
                  
                    //  originCell.setNeedsLayout()
                }
                if let cell = self.tableView.cellForRow(at: self.indexPath) as? ShowMovieTableViewCell {
                    if cell.backGropImageView != nil {
                        cell.backGropImageView.image = imageView
                        
                    }
                    if cell.posterImageView != nil {
                        cell.posterImageView.image = imageView
                        
                        
                    }
                }
            }
        }
    }
}
