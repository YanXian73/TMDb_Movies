//
//  SecanViewController.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/7/20.
//

import UIKit

class SecondViewController: UIViewController {
    var currentData = PickerData()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = self.tableView.frame.size.height/2
//        backgroundView.layer.shadowColor = UIColor.darkGray.cgColor
//        backgroundView.layer.shadowOpacity = 0.8
//        backgroundView.layer.shadowOffset = CGSize(width: 10, height: 10)
     //   imageView.image = currentData.image
        
       self.tableView.dataSource = self
      //  self.imageView.image 
        // Do any additional setup after loading the view.
    }
    
    @IBAction func done(_ sender: Any) {
        
        
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
extension SecondViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "meCell", for: indexPath) as! MeTableViewCell
        
        
        cell.imageV.image = currentData.image
        cell.layer.cornerRadius = 30
        let shadowPath2 = UIBezierPath(rect: cell.bounds)
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.darkGray.cgColor
        cell.layer.shadowOffset = CGSize(width: CGFloat(10), height: CGFloat(10))
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowPath = shadowPath2.cgPath
        cell.backgroundColor = .orange
        
        return cell
    }
}
