//
//  VideoViewController.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/8/7.
//

import UIKit
import WebKit

class VideoViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    var currentMovie = MoviesData()
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.configuration.allowsInlineMediaPlayback = false
   
    }
    func showVideo(currentMovie: MoviesData) {
        
        var movieVideo = [MovieVideo]()
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(currentMovie.id ?? 0)/videos?api_key=39ba2275337b048cb87893b4520b0c94&language=eu-US") else {return }
        
        let request = URLRequest(url: url)
        let session = URLSession.shared.dataTask(with: request) { data, response, error in
            let jsonDecoder = JSONDecoder()
            if let data = data, let results = try? jsonDecoder.decode(Result.self, from: data),
               let ok = results.resultKey, !ok.isEmpty {
                movieVideo = ok
                if let key = movieVideo[0].key, let site = movieVideo[0].site {
                    if site == "YouTube" {
                        let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(key)")
                        let request = URLRequest(url: youtubeURL!)
                        DispatchQueue.main.async {
                            self.webView.load(request)
                        }
                    }
                }
            }else{
                let alert = UIAlertController(title: "未提供資訊", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "確定", style: .cancel, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                } ))
                self.present(alert, animated: true, completion: nil)
              
            }
        }
        session.resume()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.webView.stopLoading()
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
