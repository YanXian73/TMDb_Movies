//
//  SettingViewController.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/8/10.
//
import MessageUI
import UIKit
import CoreData

class SettingViewController: UIViewController, MFMailComposeViewControllerDelegate {
    

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var remind: [Remind]!
    var text = ["在App Store給我們評分", "寫信給開發者", "TMAD官網"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none // 設定分隔號樣式(底線)
        label.text = ""
        tableView.dataSource = self
        tableView.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    func askForRating() {
        let askController = UIAlertController(title: "評分", message: "如果您喜歡這個App，請幫我們在App Store評分，謝謝您！", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "我要評分", style: .default) { action in
            let appID = "12345"
            let appURL = URL(string: "https://itunes.apple.com/us/app/itunes-u/id\(appID)?action=write-review")!
            UIApplication.shared.open(appURL, options: [:]) { success in
            }
        }
        askController.addAction(okAction)
        let laterAction = UIAlertAction(title: "稍後在評", style: .default, handler: nil)
        askController.addAction(laterAction)
        self.present(askController, animated: true, completion: nil)
    }
    func urlFromTMDB() {
           if let url = URL(string: "https://www.themoviedb.org/?language=zh-TW") {
               UIApplication.shared.open(url, options: [:], completionHandler: nil)
           }
           
       }
    func supportEmail() {
        if (MFMailComposeViewController.canSendMail()) {
            let alert = UIAlertController(title: "", message: "請回給我們建議，讓我們變得更好！", preferredStyle: .alert)
           
            let email = UIAlertAction(title: "email", style: .default) { action in
                let mailController = MFMailComposeViewController()
                mailController.mailComposeDelegate = self
                mailController.title = "mail"
                mailController.setSubject("給App建議")
                let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
                let product = Bundle.main.object(forInfoDictionaryKey: "CFBundleName")
                let messageBody = "<br/><br/><br/>Product:\(product!)(\(version!))"
                mailController.setMessageBody(messageBody, isHTML: true)
                mailController.setToRecipients(["efrtyjukopp@gmail.com"])
                self.present(mailController, animated: true, completion: nil)
            }
           
            alert.addAction(email)
            let cancel = UIAlertAction(title: "取消", style: .default, handler: nil)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }else{
            // alert user can't send email
        }
    }
    //MARK:MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("user cancelled")
        case .failed:
            print("user failed")
        case .saved:
            print("user saved")
        case .sent:
            print("user send")
        default:
            print("")
        }
        self.dismiss(animated: true, completion: nil)
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
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//         headerView.backgroundColor = UIColor.clear
//
//        return headerView
//    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //        let header = view as! UITableViewHeaderFooterView
        //        header.backgroundView?.backgroundColor = UIColor.clear
        //        header.textLabel?.font = UIFont(name: "通知", size: 50)
        //  header.textLabel?.textColor = UIColor.blue
        view.tintColor = UIColor.clear
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.black
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
        

        return self.text.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        cell.textLabel?.text = self.text[indexPath.row]
        switch indexPath.row {
        case 0:
            cell.imageView?.image = UIImage(systemName: "star.circle")
            
        case 1:
            cell.imageView?.image = UIImage(systemName: "square.and.pencil")
        default:
            cell.imageView?.image = UIImage(systemName: "desktopcomputer")
        }
        return cell
        
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
        switch indexPath.row {
        case 0:
            self.askForRating()
        case 1:
            self.supportEmail()
        default:
            self.urlFromTMDB()
        }
    }
}
