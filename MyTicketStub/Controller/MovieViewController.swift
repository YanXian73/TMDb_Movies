//
//  MovieViewController.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/7/24.
//

import UIKit

class MovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var indexPath : IndexPath?
    var movieData = [MoviesData]()
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
     //  getMoviesInfo()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func getMoviesInfo(){
        var url : URL?
        
        switch indexPath?.row {
        case 0: // 即將上映
            url = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=39ba2275337b048cb87893b4520b0c94&language=zh-TW&page=1&region=TW")
        case 1: // 現正上映中
            url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=39ba2275337b048cb87893b4520b0c94&language=zh-TW&page=1&region=TW")
        case 2: // 最受歡迎電影
            url = URL(string:
                        "https://api.themoviedb.org/3/movie/popular?api_key=39ba2275337b048cb87893b4520b0c94&language=zh-TW&page=1&region=TW")
        default:  //最高評分電影
            url = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=39ba2275337b048cb87893b4520b0c94&language=zh-TW&page=1&region=TW")
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
                self.movieData = item.results
            }
    }
        session.resume()
    }
    
    
    
    //MARK: UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return self.movieData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "moviesCell", for: indexPath) as! MoviesTableViewCell
        
        cell.titleLabel.text = self.movieData[indexPath.row].title
        cell.releaseDateLabel.text = self.movieData[indexPath.row].release_date
        cell.voteLabel.text = "\(self.movieData[indexPath.row].vote_average ?? 0.0)"
        
        //取得TMDB網址的圖片
        if let imageKey = self.movieData[indexPath.row].poster_path {
            if let imageURL = URL(string: "https://image.tmdb.org/t/p/w500" + imageKey) {
                let request = URLRequest(url: imageURL)
                let session = URLSession.shared.dataTask(with: request) { data, responds, error in
                    if let data = data {
                        DispatchQueue.main.async {
                            cell.movieImageView.image = UIImage(data: data)
                        }
                    }
                }
                session.resume()
            }
        }
        
        return cell
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
