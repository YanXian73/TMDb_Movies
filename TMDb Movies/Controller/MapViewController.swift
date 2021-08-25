//
//  MapViewController.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/7/22.
//
import CoreLocation
import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    
    var locationManager = CLLocationManager()
    var searchController = UISearchController(searchResultsController: nil)
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if  let url = URL(string:"https://data.ntpc.gov.tw/api/datasets/61C99F42-8A90-4ADC-9C40-BA9E0EA097AA/json/preview"){
            let content = try? String(contentsOf: url, encoding: .utf8)
            
        }
        map.delegate = self
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() != false {
            locationManager.activityType = .automotiveNavigation
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.delegate = self
       //     locationManager.startUpdatingLocation()
          //  moveAndZoomMap()
        }else{}
        
        self.navigationItem.searchController = self.searchController
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 首次使用 向使用者詢問定位自身位置權限
        locationManager.requestAlwaysAuthorization()
    
        }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func moveAndZoomMap(){ // 打開地圖就定位在正中心且放大
        guard let coordinate = locationManager.location?.coordinate else{
            assertionFailure("Invalid coordinate")
            return
        }
        //Prepare region
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) //地圖中心的縮放 數字越小縮放越大
        let region = MKCoordinateRegion(center: coordinate, span: span)
        //Move and Zoom map
        map.setRegion(region, animated: true)
    }
    
    //MARK:MKMapViewDelegate
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let region = mapView.region
        let center = region.center
        print("Map region changed:  \(center.latitude),\(center.longitude)")
        if locationManager.location?.coordinate != nil {
            
            moveAndZoomMap()
        }
    }
    
    
    //MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
   //    guard let currentLocation = locations.last  else{
        assertionFailure("Invalid coordinate")
            return
        
 //       }
        
    }
    
}
