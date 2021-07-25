//
//  MovieViewController.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/7/24.
//

import UIKit

class MovieViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

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
                            movieData.tital = d["original_title"] as? String
                            movieData.release_date = d["release_date"] as? Date
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
        // Do any additional setup after loading the view.
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
