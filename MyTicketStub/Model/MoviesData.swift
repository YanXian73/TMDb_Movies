//
//  Movies.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/7/24.
//
import CoreData
import Foundation
//解碼json資料要繼承 Codable解碼, Decodable
struct MoviesData : Codable{
    
    
    //取得TMDB電影的API的 json資料 命名要跟想要拿的 key 一樣
    var id:Int?
    var original_title : String?
    var title : String?
    var vote_average: Double?
    var release_date: String?
    var poster_path : String?
    var overview : String?
    var backdrop_path : String?
    var popularity : Double?
}
struct Item: Codable {
    var results : [MoviesData]
    var total_pages : Int
    var page : Int
    var total_results : Int
}
struct Dates : Codable {
    var dates :Dictionary<String, String>
}

struct MovieVideo : Codable {
    var key : String?
    var site: String?
}

struct Result : Codable {
    
    var resultKey : [MovieVideo]?
    
    enum CodingKeys: String, CodingKey {
        case resultKey = "results"
    }
}

