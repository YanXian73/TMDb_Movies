//
//  ShowMovieViewController.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/7/27.
//

import UIKit

class ShowMovieViewController: UIViewController {

    @IBOutlet weak var originTitleLabel: UILabel!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var overViewTextView: UITextView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var starBtn: UIButton!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var backdropImage: UIImageView!
    
    var currentMovie = MoviesData()
    
    override func viewDidLoad() {
        super.viewDidLoad()

   //     overViewLabel.sizeToFit()
        originTitleLabel.text = currentMovie.original_title
        titleLabel.text = currentMovie.title
        releaseDateLabel.text = currentMovie.release_date
        overViewTextView.text = currentMovie.overview
        voteLabel.text = "\(currentMovie.vote_average ?? 0)"
        getMovieImage(imageKey: currentMovie.poster_path, imageView: posterImage)
        getMovieImage(imageKey: currentMovie.backdrop_path, imageView: backdropImage)
        
        scrollView.addSubview(overViewTextView)
    //    scrollView.contentSize = overViewTextView.contentSize
      //  scrollView.contentSize = CGSize(width: 384, height: 1000)
    }
    func getMovieImage(imageKey: String?, imageView: UIImageView) {
        if let imageKey = imageKey {
            if let imageURL = URL(string: "https://image.tmdb.org/t/p/w500" + imageKey) {
                let request = URLRequest(url: imageURL)
                let session = URLSession.shared.dataTask(with: request) { data, responds, error in
                    if let data = data {
                        let imag = UIImage(data: data)
                        DispatchQueue.main.async {
                            imageView.image = imag
                        }
                    }
                    if let e = error {
                        assertionFailure("\(e)")
                        return
                    }
                }
                session.resume()
            }
        }else {
            print("圖片的API有問題！")
          //  imageView.image  = imageView
        }
    }
    
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        let myMovie = MyMoviesTableViewController()
        //先把資料存起來
        //通知myMovie做更新
        myMovie.didupdate(movie: self.currentMovie)
        
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
