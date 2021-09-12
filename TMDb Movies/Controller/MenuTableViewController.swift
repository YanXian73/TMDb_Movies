//
//  MenuTableViewController.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/7/26.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
  //  var menuData = [MoviesData]()

    let moviesCellTitle = ["即將上映", "現正放映", "熱門電影", "好評電影"]
    let images : [UIImage] = [UIImage(named: "NEW.jpg")!, UIImage(named: "movie.png")!, UIImage(named: "Hot.png")!, UIImage(systemName: "star.fill")!]
    override func viewDidLoad() {
        super.viewDidLoad()
        NetStatus.shared.startMonitoring() //開始監控網路狀態
        
        tableView.rowHeight = tableView.frame.height/5 - 25
     
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "segueMovieVC" , NetStatus.shared.isConnected else {
            let alert = UIAlertController(title: "請檢查網路狀態", message: "", preferredStyle: .alert)
            let ok = UIAlertAction(title: "取消", style: .cancel)
            alert.addAction(ok)
            present(alert, animated: true)
            return
        }
        if let movieVC = segue.destination as? MoviesViewController,
           let index = tableView.indexPathForSelectedRow {
            movieVC.indexPath = index
            movieVC.getMoviesInfo(pages: movieVC.page)
            movieVC.navigationItem.title = moviesCellTitle[index.section]
        }
    }

    // MARK: - Table view data source
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0 {
//            let text = "＊＊＊＊＊＊＊＊＊院線區＊＊＊＊＊＊＊＊＊"
//
//            return text
//        }else {
//            return "＊＊＊＊＊＊＊＊＊選片區＊＊＊＊＊＊＊＊＊"
//        }
//    }
//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if section == 1{
//            return 100
//        }
//        return 0
//    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = UIView()
         headerView.backgroundColor = UIColor.clear

        return headerView
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.moviesCellTitle.count
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
     
        return 1
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuTableViewCell
        
        cell.menuImageView.image = self.images[indexPath.section]
        cell.menuLabel.text = moviesCellTitle[indexPath.section]
        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowOpacity = 0.5
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = false
        return cell
//        cell.imageView?.image = self.images[indexPath.section]
//        cell.textLabel?.text = self.moviesCellTitle[indexPath.section]
//        return cell
        
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
