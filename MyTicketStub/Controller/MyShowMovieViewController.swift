//
//  MyShowMovieViewController.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/8/8.
//

import UIKit
import UserNotifications

class MyShowMovieViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    var currentMovie = MyMovieList()
    var queue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.dataSource = self
        tableView.delegate = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension MyShowMovieViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell0 = tableView.dequeueReusableCell(withIdentifier: "cell0", for: indexPath) as! ShowMovieTableViewCell
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! ShowMovieTableViewCell
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! ShowMovieTableViewCell
        let cell3 = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! ShowMovieTableViewCell
        let cell4 = tableView.dequeueReusableCell(withIdentifier: "cell4", for: indexPath) as! ShowMovieTableViewCell
        let cell5 = tableView.dequeueReusableCell(withIdentifier: "cell5", for: indexPath) as! ShowMovieTableViewCell

        
        switch indexPath.row {
        case 0:
            if let imageKey = self.currentMovie.poster_path {
                if let imageURL = URL(string: "https://image.tmdb.org/t/p/w500" + imageKey) {
                    
                    let operation = ImageOperation(url: imageURL, indexPath: indexPath, tableView: tableView)
                    self.queue.addOperation(operation)
                }
                
            }else{
                cell0.posterImageView.image = UIImage(named: "XXX.png")
            }
            return cell0
            
        case 1:
            cell1.datePicker.datePickerMode = .dateAndTime
            cell1.datePicker.minuteInterval = 10
            cell1.remindLabel.text = "設定提醒"
//            date.year = Int(dateContent.prefix(4))
//            let beginString = dateContent.index(dateContent.startIndex, offsetBy: 5)
//            let endString = dateContent.index(beginString, offsetBy: 2)
//            let month = dateContent[beginString..<endString]
//            date.month = Int(month)
//            let beginDay = dateContent.index(dateContent.startIndex, offsetBy: 8)
//            let endDay = dateContent.index(beginDay, offsetBy: 2)
//            let day = dateContent[beginDay..<endDay]
//            date.day = Int(day)
            
            return cell1
        case 2:
            
            if currentMovie.original_title != currentMovie.title {
                cell2.originTitleLabel.text = currentMovie.original_title
            }else {
                cell2.originTitleLabel.text = ""
            }
            cell2.titleLabel.text = currentMovie.title
            cell2.releaseDateLabel.text = "上映日期：" + "\(currentMovie.release_date ?? "")"
            cell2.voteLabel.text = "\(currentMovie.vote_average )"
//            if let imageKey = self.currentMovie.poster_path {
//                if let imageURL = URL(string: "https://image.tmdb.org/t/p/w500" + imageKey) {
//
//                    let operation = ImageOperation(url: imageURL, indexPath: indexPath, tableView: tableView)
//                    self.queue.addOperation(operation)
//                }
//            }else {
//                cell1.posterImageView.image = UIImage(named: "XXX.png")
//            }
            
            return cell2
            
        case 3:
            if let overView = currentMovie.overview {
                cell3.overViewLabel.text = overView
            }
            return cell3
        case 4:
        
            cell4.videoLabel.text = "觀看預告片"
            return cell4
            
        default:
            if let imageKey = self.currentMovie.backdrop_path {
                if let imageURL = URL(string: "https://image.tmdb.org/t/p/w500" + imageKey) {
                    
                    let operation = ImageOperation(url: imageURL, indexPath: indexPath, tableView: tableView)
                    self.queue.addOperation(operation)
                }
            }else{
                cell5.backGropImageView.image = UIImage(named: "XXX.png")
            }
            return cell5
        } // switch
    }// func
    }
    
    

