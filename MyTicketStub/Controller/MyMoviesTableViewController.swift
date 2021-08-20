//
//  MyMoviesTableViewController.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/7/28.
//
import CoreData
import UIKit

class MyMoviesTableViewController: UITableViewController, ShowMovieTableViewControllerDelegate {

    func removeFavoriteRow(movieeData: MoviesData) {
      let movie = self.myMovieList.filter { movie in
            return movie.id == movieeData.id
        }
        let moc = CoreDataHelper.shared.managedObjectContext()
        moc.performAndWait {
            moc.delete(movie.first!)
        }
        CoreDataHelper.shared.saveContext()
    }
    
    func addFavoriteRow(movieData: MoviesData) {
        let moc = CoreDataHelper.shared.managedObjectContext()
        let data = MyMovieList(context: moc)
        data.original_title = movieData.original_title
        data.title = movieData.title
        data.backdrop_path = movieData.backdrop_path
        data.poster_path = movieData.poster_path
        data.overview = movieData.overview
        data.release_date = movieData.release_date
        data.vote_average = movieData.vote_average!
        data.id = movieData.id!
        CoreDataHelper.shared.saveContext()

    }
    
    var label : UILabel?
    var isEmptyImage = [UIImage]()
    var myMovieList : [MyMovieList]!
    var currentMovie = MoviesData()
    let queue = OperationQueue()
    override func viewDidLoad() {
        super.viewDidLoad()

        queue.maxConcurrentOperationCount = 2
        tableView.rowHeight = 175
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        queryFromDB()
        self.tableView.reloadData()
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        self.tableView.setEditing(editing, animated: true)

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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "myShowMovie" {
            if let myShowVC = segue.destination as? MyShowMovieViewController,
               let index = tableView.indexPathForSelectedRow {
                let movie = myMovieList[index.row]
                myShowVC.currentMovie = movie
            }
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
        if self.myMovieList.isEmpty {
            self.tableView.setEmptyMessage("目前清單是空的，前往電影分類詳細資訊頁面->點擊右上角星星，新增／移除我的片單！")
        }else{
            self.tableView.restore()
        }
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
                
            }
        }
        return cell
        
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           let movie = self.myMovieList.remove(at: indexPath.row)
            let moc = CoreDataHelper.shared.managedObjectContext()
            moc.performAndWait {
                moc.delete(movie)
            }
            CoreDataHelper.shared.saveContext()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
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
extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 35)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
