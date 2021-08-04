//
//  MyMoviesTableViewController.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/7/28.
//
import CoreData
import UIKit

class MyMoviesTableViewController: UITableViewController, ShowMovieTableViewControllerDelegate {
    func diddidUpdate(movieData: MoviesData) {
        let moc = MyCoreData.shared.managedObjectContext()
        let data = MyMovieList(context: moc)
        data.original_title = movieData.original_title
        data.title = movieData.title
        data.backdrop_path = movieData.backdrop_path
        data.poster_path = movieData.poster_path
        data.overview = movieData.overview
        data.release_date = movieData.release_date
        MyCoreData.shared.saveContext()
        self.myMovieList.append(data)
    }
    let showMovieTVC = ShowMovieTableViewController()

    var myMovieList : [MyMovieList]!
    var currentMovie = MoviesData()
    let queue = OperationQueue()
    override func viewDidLoad() {
        super.viewDidLoad()

        showMovieTVC.delegate = self
        queryFromDB()
        queue.maxConcurrentOperationCount = 2
        tableView.rowHeight = 175
        
        
        
    }
    //MARK: Core Data
    func queryFromDB()  {
        let moc = MyCoreData.shared.managedObjectContext()
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
 

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.myMovieList.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MoviesTableViewCell

        cell.titleLabel.text = self.myMovieList[indexPath.row].title
        cell.releaseDateLabel.text = "上映日期：\(self.myMovieList[indexPath.row].release_date ?? "")"
        cell.voteLabel.text = "\(self.myMovieList[indexPath.row].vote_average )"
        cell.movieImageView.image = nil //cell可能被reuse，所以要先清除原本的照片，否則會看到原照片的殘影
        //取得TMDB網址的圖片
        if let imageKey = self.myMovieList[indexPath.row].poster_path {
            if let imageURL = URL(string: "https://image.tmdb.org/t/p/w342" + imageKey) {
                
                let operation = ImageOperation(url: imageURL, indexPath: indexPath, tableView: tableView)
                self.queue.addOperation(operation)
                
//                let session = URLSession.shared.dataTask(with: request) { data, responds, error in
//                    if let data = data {
//                        DispatchQueue.main.async {
//                            cell.movieImageView.image = UIImage(data: data)
//                        }
//                    }
//                }
//                session.resume()
            }
        }
        return cell
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
