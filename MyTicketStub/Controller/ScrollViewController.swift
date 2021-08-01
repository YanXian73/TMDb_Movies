//
//  ScrollViewController.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/7/22.
//

import UIKit
protocol ScrollViewControllerDeleage: AnyObject {
    func didupdateView(ticketStub: TicketStub)
}

class ScrollViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var datePicker: UIDatePicker!
  
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet var textLabel: [UILabel]!
    @IBOutlet weak var textField: UITextField!
    
    let moc = CoreDataHelper.shared.managedObjectContext()
    var image = UIImage()
  //  var currentData : TicketStub!
    var firstVC : FirstViewController?
    var textTitle = ["主題：", "日期：", "標籤：", "備註："]
    var currentDate = Date()
    @IBOutlet weak var textView: UITextView!
    weak var delegate : ScrollViewControllerDeleage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for index in 0...textLabel.count-1 {
            textLabel[index].text = textTitle[index]
        }
        textField.delegate = self
        textField.placeholder = "必填"
        datePicker.datePickerMode = .dateAndTime
        datePicker.minuteInterval = 10
        //  datePicker.preferredDatePickerStyle = .wheels
        datePicker.date = Date()
        //   DateFormatter.localizedString(from: datePicker.date, dateStyle: .long, timeStyle: .short)
        // dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //顯示的日期時間格式
        //datePicker.setDate(self.datePicker.date, animated: true)
       // datePicker.addTarget(self, action: #selector(datePickChanged), for: .valueChanged)
        
        imageV.image = image
        //    scrollView.contentSize = CGSize(width: 384, height: 1000)
        
        //   self.contentView.layer.cornerRadius = 20
        
    }
    
    @objc func datePickChanged(){
     //   let ticket = TicketStub(context: self.moc)
//       // let dateFormatter = DateFormatter.localizedString(from: self.datePicker.date, dateStyle: .long, timeStyle: .short) //時間樣式
//        self.datePicker.date
//        self.currentDate = dateFormatter
        print(currentDate)

    }
    @IBAction func changeMapPlace(_ sender: Any) {
        
    }
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func done(_ sender: Any) {
        let ticket = TicketStub(context: self.moc)
        ticket.title = self.textField.text
        ticket.date = DateFormatter.localizedString(from: self.datePicker.date, dateStyle: .long, timeStyle: .short) //時間樣式
        ticket.text = self.textView.text
        
        if let image = self.imageV.image {
            let home = URL(fileURLWithPath: NSHomeDirectory()) //利用URL物件組路徑
            let doc = home.appendingPathComponent("Documents") //Documents不要拼錯
            let filePath = doc.appendingPathComponent("\(ticket.id).jpg")
            if let imageData = image.jpegData(compressionQuality: 1){
                do{
                    try imageData.write(to: filePath, options: .atomic ) //寫到指定的路徑filePath
                    ticket.imageName = "\(ticket.id).jpg"
                }catch{
                    print("照片寫黨有錯\(error)")
                }
            }
        self.delegate?.didupdateView(ticketStub: ticket)
        self.dismiss(animated: true, completion: nil)
      //  self.navigationController?.popViewController(animated: true)
    }
    }
    
//MARK : UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(textField.text!)
        textField.resignFirstResponder() // 收鍵盤
        return true
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

