//
//  ShowMovieTableViewController.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/7/29.
//

import UIKit
import CoreData
protocol ShowMovieTableViewControllerDelegate: AnyObject {
    func addFavoriteRow(movieData:MoviesData)
    func removeFavoriteRow(movieeData:MoviesData)
}

class ShowMovieTableViewController: UITableViewController {
    
    var isFavorite = false
    @IBOutlet weak var myFavoriteOutlet: UIBarButtonItem!
    weak var delegate : ShowMovieTableViewControllerDelegate?
    let queue = OperationQueue()
    var currentMovie =  MoviesData()
    var myMovieList : [MyMovieList]!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        queryFromDB()
        
        for i in myMovieList {
            if i.id == currentMovie.id {
                self.myFavoriteOutlet.image = UIImage(systemName: "star.fill")
                self.isFavorite = true
            }
        }
    }
    //MARK: Core Data
    func queryFromDB()  {
        let moc = CoreDataHelper.shared.managedObjectContext()
        let request = NSFetchRequest<MyMovieList>(entityName: "MyMovieList")
        moc.performAndWait {
            do{
                let result = try moc.fetch(request)
                self.myMovieList = result
            }catch{
                print("error query db \(error)")
                self.myMovieList = []
                
            }
        }
    }
    
    @IBAction func addMyFavorite(_ sender: Any) {
        
        guard let myMovieTVC = storyboard?.instantiateViewController(withIdentifier: "myMovie") as? MyMoviesTableViewController else { return }
        self.delegate = myMovieTVC
        myMovieTVC.queryFromDB()
        if !self.isFavorite {
            self.myFavoriteOutlet.image = UIImage(systemName: "star.fill")
            self.delegate?.addFavoriteRow(movieData: currentMovie)
            self.isFavorite = true
        }else {
            
            self.delegate?.removeFavoriteRow(movieeData: currentMovie)
            self.myFavoriteOutlet.image = UIImage(systemName: "star")
            self.isFavorite = false
            
        }
        
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
            
            if currentMovie.original_title != currentMovie.title {
                cell1.originTitleLabel.text = currentMovie.original_title
            }else {
                cell1.originTitleLabel.text = ""
            }
            cell1.titleLabel.text = currentMovie.title
            cell1.releaseDateLabel.text = "上映日期：" + "\(currentMovie.release_date ?? "")"
            cell1.voteLabel.text = "\(currentMovie.vote_average ?? 0)"
//            if let imageKey = self.currentMovie.poster_path {
//                if let imageURL = URL(string: "https://image.tmdb.org/t/p/w500" + imageKey) {
//
//                    let operation = ImageOperation(url: imageURL, indexPath: indexPath, tableView: tableView)
//                    self.queue.addOperation(operation)
//                }
//            }else {
//                cell1.posterImageView.image = UIImage(named: "XXX.png")
//            }
            
            return cell1
            
        case 2:
            if let overView = currentMovie.overview {
                cell2.overViewLabel.text = "劇情介紹：\n\n    \(overView)"
            }
            return cell2
        case 3:
        
            cell3.videoLabel.text = "YouTube預告片"
            return cell3
            
        default:
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
        if segue.identifier == "segueVideo" {
            if let videoVC = segue.destination as? VideoViewController{
                videoVC.showVideo(currentMovie: currentMovie)
            }
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
