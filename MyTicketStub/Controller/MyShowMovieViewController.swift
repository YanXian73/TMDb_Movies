//
//  MyShowMovieViewController.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/8/8.
//

import UIKit
import UserNotifications
import CoreData

class MyShowMovieViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var currentMovie = MyMovieList()
    var queue = OperationQueue()
    var remind : [Remind]!
    
    var info = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.dataSource = self
        tableView.delegate = self
    }
 
    
    @IBAction func activityBtnPressed(_ sender: Any) {
        
        let tmdbURL = URL(string: "https://www.themoviedb.org/?language=zh-TW")
        if let url = URL(string: "https://www.themoviedb.org/movie/\(currentMovie.id)-\(currentMovie.original_title ?? "")?language=zh-TW"){
            self.info.append(url)
        }else{
            self.info.append(tmdbURL!)
        }
        
        if let imageKey = self.currentMovie.poster_path {
            if let imageURL = URL(string: "https://image.tmdb.org/t/p/w500" + imageKey),
               let imageDate = try? Data(contentsOf: imageURL),
               let image = UIImage(data: imageDate) {
                self.info.append(image)
            }
            let activityVC = UIActivityViewController(activityItems: [info[0], info[1]], applicationActivities: nil)
            activityVC.completionWithItemsHandler = {( activityType: UIActivity.ActivityType?, compled: Bool, returnedItem: [Any]?, error: Error?) in
                if compled {
                    let alert = UIAlertController(title: "上傳成功", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { _ in
                                                    self.info = [] }))
                    self.present(alert, animated: true, completion: nil)
                }else {
                    self.info = []
                }
            }
            present(activityVC, animated: true, completion: nil)
            
        }
    } // func activityBtnPressed
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell0 = tableView.dequeueReusableCell(withIdentifier: "cell0", for: indexPath) as! ShowMovieTableViewCell
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! ShowMovieTableViewCell
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! ShowMovieTableViewCell
        let cell3 = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! ShowMovieTableViewCell
        let cell4 = tableView.dequeueReusableCell(withIdentifier: "cell4", for: indexPath) as! ShowMovieTableViewCell
        
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
            cell1.movieNameLabel.text = "電影名稱："
            if currentMovie.original_title != currentMovie.title {
                cell1.originTitleLabel.text = currentMovie.original_title
            }else {
                cell1.originTitleLabel.text = ""
            }
            cell1.titleLabel.text = currentMovie.title
            
            
            cell1.releaseDateLabel.text = "上映日期：" + "\(currentMovie.release_date ?? "")"
            cell1.voteLabel.text = "\(currentMovie.vote_average )"
    
            cell1.datePicker.datePickerMode = .dateAndTime
            cell1.datePicker.minuteInterval = 10
            cell1.remindLabel.text = "設定提醒:"
    
            return cell1
        case 2:
            
            if let overView = currentMovie.overview {
                cell2.overViewLabel.text = "劇情介紹：\n\n    \(overView)"
            }
            
            return cell2
            
        case 3:
            cell3.videoLabel.text = "觀看預告片"
            return cell3
            
        default :
            if let imageKey = self.currentMovie.backdrop_path {
                if let imageURL = URL(string: "https://image.tmdb.org/t/p/w500" + imageKey) {
                    
                    let operation = ImageOperation(url: imageURL, indexPath: indexPath, tableView: tableView)
                    self.queue.addOperation(operation)
                }
            }else{
                cell4.backGropImageView.image = UIImage(named: "XXX.png")
            }
            
            return cell4
            
        } // switch
    }// func
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "myVideo" {
            if let videoVC = segue.destination as? VideoViewController{
                videoVC.showVideo(currentMovie: currentMovie)
            }
        }
    }
    
    
}
    
    

