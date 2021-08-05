//
//  ShowMovieTableViewController.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/7/29.
//

import UIKit
import CoreData
protocol ShowMovieTableViewControllerDelegate: AnyObject {
    func didAddRow(movieData:MoviesData)
}

class ShowMovieTableViewController: UITableViewController {
    
 
    @IBOutlet weak var myFavoriteOutlet: UIBarButtonItem!
    weak var delegate : ShowMovieTableViewControllerDelegate?
    let queue = OperationQueue()
    var currentMovie =  MoviesData()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func addMyFavorite(_ sender: Any) {
        if let myMovieTVC = storyboard?.instantiateViewController(withIdentifier: "myMovie") as? MyMoviesTableViewController {
            self.myFavoriteOutlet.image = UIImage(systemName: "star.fill")
            self.delegate = myMovieTVC
            
            self.delegate?.didAddRow(movieData: currentMovie)
        }
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell0 = tableView.dequeueReusableCell(withIdentifier: "cell0", for: indexPath) as! ShowMovieTableViewCell
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! ShowMovieTableViewCell
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! ShowMovieTableViewCell
        let cell3 = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! ShowMovieTableViewCell
       
        
        switch indexPath.row {
        case 0:
            if let imageKey = self.currentMovie.backdrop_path {
                if let imageURL = URL(string: "https://image.tmdb.org/t/p/w500" + imageKey) {
                    
                    let operation = ImageOperation(url: imageURL, indexPath: indexPath, tableView: tableView)
                    self.queue.addOperation(operation)
                }
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
            if let imageKey = self.currentMovie.poster_path {
                if let imageURL = URL(string: "https://image.tmdb.org/t/p/w500" + imageKey) {
                    
                    let operation = ImageOperation(url: imageURL, indexPath: indexPath, tableView: tableView)
                    self.queue.addOperation(operation)
                }
            }
            return cell1
        case 2:
            if let overView = currentMovie.overview {
                cell2.overViewLabel.text = overView
            }
            return cell2
        default :
            var movieVideo = [MovieVideo]()
            guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(currentMovie.id ?? 0)/videos?api_key=39ba2275337b048cb87893b4520b0c94&language=eu-US") else {return cell3}
            
            let request = URLRequest(url: url)
            let session = URLSession.shared.dataTask(with: request) { data, response, error in
                let jsonDecoder = JSONDecoder()
                if let data = data ,let results = try? jsonDecoder.decode(Result.self, from: data),
                   let ok = results.resultKey, !ok.isEmpty {
                    movieVideo = ok
                    if let key = movieVideo[0].key, let site = movieVideo[0].site {
                        if site == "YouTube" {
                            let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(key)")
                            // UIApplication.shared.open(youtubeURL!, options: [:])
                            
                            DispatchQueue.main.async {
                                cell3.videoBtnOutlet.setTitle("\(youtubeURL!)", for: .normal)
                                cell3.label.text = "預告片"
                            }
                        }
                    }
                }
            }
            session.resume()
            
           
            return cell3
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
