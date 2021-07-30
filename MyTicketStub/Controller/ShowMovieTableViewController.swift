//
//  ShowMovieTableViewController.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/7/29.
//

import UIKit

class ShowMovieTableViewController: UITableViewController {
    
 

    let queue = OperationQueue()
    var currentMovie =  MoviesData()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell0 = tableView.dequeueReusableCell(withIdentifier: "cell0", for: indexPath) as! ShowMovieTableViewCell
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! ShowMovieTableViewCell
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! ShowMovieTableViewCell
     
       
        
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
        default:
            if let overView = currentMovie.overview {
                cell2.overViewLabel.text = overView
            }
            return cell2
            
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
