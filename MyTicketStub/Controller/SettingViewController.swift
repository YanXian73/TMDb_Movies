//
//  SettingViewController.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/8/10.
//

import UIKit
import CoreData

class SettingViewController: UIViewController {
    

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var remind: [Remind]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = ""
        tableView.dataSource = self
        tableView.delegate = self
  //      self.navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        queryFromDB()
        tableView.reloadData()
    }
//    override func setEditing(_ editing: Bool, animated: Bool) {
//        super.setEditing(editing, animated: true)
//        tableView.setEditing(editing, animated: true)
//
//    }
    
    //MARK: Core Data
    func queryFromDB()  {
        
        let moc = CoreDataHelper.shared.managedObjectContext()
        let request = NSFetchRequest<Remind>(entityName: "Remind")
        moc.performAndWait {
            do{
            let result = try moc.fetch(request)
                self.remind = result
            }catch{
                print("error query db \(error)")
                self.remind = []
            }
        }
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
//MARK: UITableViewDataSource, UITableViewDelegate
extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "相關連結"
            
        default:
            return "相關連結"
        }
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "通知", size: 30)
      //  header.textLabel?.textColor = UIColor.blue
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section  {
        case 5: //先不用
            return self.remind.count
        default:
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 5: //先不用
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            cell.textLabel?.text = self.remind[indexPath.row].movieName
            cell.detailTextLabel?.text = self.remind[indexPath.row].remind
            cell.imageView?.image = UIImage(systemName: "")
            return cell
            
        default: //都只先顯示這個cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! SettingTableViewCell
            cell.urlBtnOutlet.setTitle("TMDB官網", for: .normal)
            return cell
        }
   }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let remind = self.remind.remove(at: indexPath.row)
//             let moc = CoreDataHelper.shared.managedObjectContext()
//             moc.performAndWait {
//                 moc.delete(remind)
//             }
//             CoreDataHelper.shared.saveContext()
//            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(remind.movieName ?? "")"])
//             self.tableView.deleteRows(at: [indexPath], with: .automatic)
//        }
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
