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
    var dates : Dates?
    var searchYear = "2021"
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
     
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        queue.maxConcurrentOperationCount = 2
        tableView.rowHeight = 175
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    func getMoviesInfo(pages: Int){
        
        
        var url : URL?
        
        let region = "&region=TW"
        switch indexPath?.section {
        case 0: // 即將上映電影
            url = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=39ba2275337b048cb87893b4520b0c94&language=zh-TW&page=\(pages)\(region)")
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
              //  self.dates = item.dates
                self.movieData += item.results
                self.page = item.page + 1
                self.totalPages = item.total_pages
                DispatchQueue.main.async { //下載完成之後要重新更新畫面
                    self.tableView.reloadData()
                    self.pageStatus = .NotLoadingMore
                }
            }
            if let data = data, let item = try? decoder.decode(Dates.self, from: data) {
                self.dates = item
                DispatchQueue.main.async { //下載完成之後要重新更新畫面
                    self.tableView.reloadData()
                    self.pageStatus = .NotLoadingMore
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
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if self.indexPath?.section == 0 || self.indexPath?.section == 1 {
            if  let date = self.dates {
                return "搜尋日期： \(date.dates["minimum"] ?? "")  ~  \(date.dates["maximum"] ?? "")"
            }
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.indexPath?.section == 0 || self.indexPath?.section == 1 {
            self.movieData = self.movieData.filter({$0.release_date?.contains("\(searchYear)") == true})
        }
        return self.movieData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "moviesCell", for: indexPath) as! MoviesTableViewCell
     //   cell.popularLabel.text = "人氣:\(self.movieData[indexPath.row].popularity ?? 0)"
        cell.titleLabel.text = self.movieData[indexPath.row].title
        cell.releaseDateLabel.text = "上映日期：\(self.movieData[indexPath.row].release_date ?? "")"
        cell.voteLabel.text = "\(self.movieData[indexPath.row].vote_average ?? 0.0)"
        cell.movieImageView.image = nil //cell可能被reuse，所以要先清除原本的照片，否則會看到原照片的殘影
        //取得TMDB網址的圖片
        if let imageKey = self.movieData[indexPath.row].poster_path {
            if let imageURL = URL(string: "https://image.tmdb.org/t/p/w342" + imageKey) {
                
                let operation = ImageOperation(url: imageURL, indexPath: indexPath, tableView: tableView)
                self.queue.addOperation(operation)
                
            }
        }else{
            cell.movieImageView.image = UIImage(named: "XXX.png")
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
            
            if self.page <= self.totalPages {
                self.pageStatus = .LoadingMore
                self.getMoviesInfo(pages: self.page)
            }
        }
        
        //     self.tableView.reloadData
        // 模擬 Call API 的時間
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        //                self.pageStatus = .NotLoadingMore
        //                self.tableView.reloadData()
//            }
        
    }
}



