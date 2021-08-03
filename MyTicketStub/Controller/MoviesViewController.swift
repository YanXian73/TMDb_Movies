//
//  MovieViewController.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/7/24.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    enum PageStatus {
        case LoadingMore
        case NotLoadingMore
    }
    var pageStatus : PageStatus = .NotLoadingMore
    
    var indexPath : IndexPath?
    var movieData = [MoviesData]()
    var page : Int = 1
    var totalPages: Int!
    var queue = OperationQueue()
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
     
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        queue.maxConcurrentOperationCount = 2
        tableView.rowHeight = 175
        tableView.dataSource = self
        tableView.delegate = self
        
      
        
        
        /*
        if let url_2020 = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=39ba2275337b048cb87893b4520b0c94&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&year=2020&with_watch_monetization_types=flatrate"){
            let request = URLRequest(url: url_2020)
            let session = URLSession.shared.dataTask(with: request) { data, responds, error in
                if let jsonData = data {
                    do{
                        let data = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! Dictionary<String, Any>
                        print(data)
                        
                        var movieData = MoviesData()
                        if let results = data["results"] as? [Any],
                           let d = results.first as? Dictionary<String, Any> {
                            
                            movieData.title = d["original_title"] as? String
                            movieData.release_date = d["release_date"] as? String
                            movieData.vote_average = d["vote_average"] as? Double
                            movieData.poster_path = d["poster_path"] as? String
                            print(movieData) // 日期跟圖片還沒搞定
                        }
                    }catch{
                        print("error11111111111") }
         }
         }
         session.resume()
         }
         */
       
    }
    @IBAction func addMyMovieList(_ sender: Any) {
        let myMovie = MyMoviesTableViewController()
        var  movie = MoviesData()
        
        //用Button的方式 拿不到 tableView.indexPathForSelectedRow
//        if  let  index =  tableView.indexPathForSelectedRow  {
//            movie = self.movieData[index.row]
//            myMovie.currentMovie = movie
//        }
        
    }
    
    func getMoviesInfo(pages: Int){
        var url : URL?
        
        let region = "&region=TW"
        switch indexPath?.row {
        case 0: // 最新的電影
            url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=39ba2275337b048cb87893b4520b0c94&language=zh-TW\(region)&sort_by=release_date.desc&include_adult=false&include_video=false&page=\(page)&with_watch_monetization_types=flatrate")
        case 1: // 現正上映中
            url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=39ba2275337b048cb87893b4520b0c94&language=zh-TW&page=\(pages)\(region)")
        case 2: // 最受歡迎電影
            url = URL(string:
                        "https://api.themoviedb.org/3/movie/popular?api_key=39ba2275337b048cb87893b4520b0c94&language=zh-TW&page=\(pages)\(region)")
        default:  //最高評分電影
            url = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=39ba2275337b048cb87893b4520b0c94&language=zh-TW&page=\(pages)\(region)")
        }
        
        guard let requestURL = url
        else{ return }
        let request = URLRequest(url: requestURL)
        let session = URLSession.shared.dataTask(with: request) { data, responds, error in
            let decoder = JSONDecoder()
            if let e = error {
                assertionFailure("error: \(e)")
                return
            }
            
            if let data = data, let item = try? decoder.decode(Item.self, from: data) {
                self.movieData += item.results
                self.page = item.page + 1
                self.totalPages = item.total_pages
                
                if self.page <= self.totalPages {
                    self.getMoviesInfo(pages: self.page)
                }
                DispatchQueue.main.async { //下載完成之後要重新更新畫面
                    if self.movieData.count < 50 {
                        self.tableView.reloadData()
                    }
                    
                }
                
            }
        }
        session.resume()
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovieTVC" {
            if let showMovieVC = segue.destination as? ShowMovieTableViewController,
               let indexPath = tableView.indexPathForSelectedRow {
                let  movie = self.movieData[indexPath.row]
                showMovieVC.currentMovie = movie
            }
        }
    }
    
    
    
    //MARK: UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return self.movieData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "moviesCell", for: indexPath) as! MoviesTableViewCell
       
        cell.titleLabel.text = self.movieData[indexPath.row].title
        cell.releaseDateLabel.text = "上映日期：\(self.movieData[indexPath.row].release_date ?? "")"
        cell.voteLabel.text = "\(self.movieData[indexPath.row].vote_average ?? 0.0)"
        cell.movieImageView.image = nil //cell可能被reuse，所以要先清除原本的照片，否則會看到原照片的殘影
        //取得TMDB網址的圖片
        if let imageKey = self.movieData[indexPath.row].poster_path {
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
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //...
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
extension MoviesViewController : UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView.contentSize.height > self.tableView.frame.height,
              self.pageStatus == .NotLoadingMore else { return }
        
        if scrollView.contentSize.height - (scrollView.frame.size.height + scrollView.contentOffset.y) <= -10 {
            
            self.pageStatus = .LoadingMore
            //     self.tableView.reloadData
            // 模擬 Call API 的時間
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.pageStatus = .NotLoadingMore
                self.tableView.reloadData()
            }
        }
        
    }
}



