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

class ScrollViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var datePicker: UIDatePicker!

    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet var textLabel: [UILabel]!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    weak var delegate : ScrollViewControllerDeleage?
 
    var currentTicket: TicketStub?
    let moc = CoreDataHelper.shared.managedObjectContext()
    var image = UIImage()
  //  var currentData : TicketStub!
    var firstVC : FirstViewController?
    var textTitle = ["主題：", "日期：", "標籤：", "備註："]
    var nowDate = Date()
    var isNewImage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for index in 0...textLabel.count-1 {
            textLabel[index].text = textTitle[index]
        }
        
        textField.text = currentTicket?.title
        textView.text = currentTicket?.contentText
        datePicker.date = timeStringToDate(currentTicket?.date ?? "\(Date())") ?? Date()
        textView.delegate = self
        textField.delegate = self
        textField.placeholder = "主題"
        datePicker.datePickerMode = .dateAndTime
        datePicker.minuteInterval = 10
        //  datePicker.preferredDatePickerStyle = .wheels
        datePicker.date = Date()
        //   DateFormatter.localizedString(from: datePicker.date, dateStyle: .long, timeStyle: .short)
        // dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //顯示的日期時間格式
        //datePicker.setDate(self.datePicker.date, animated: true)
       // datePicker.addTarget(self, action: #selector(datePickChanged), for: .valueChanged)
    
 //      self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        imageV.image = image
        //    scrollView.contentSize = CGSize(width: 384, height: 1000)
        
        //   self.contentView.layer.cornerRadius = 20
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textView.resignFirstResponder()
        textField.resignFirstResponder()
    }
    func timeStringToDate(_ dateStr:String) ->Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd aa HH:mm"
        let date = dateFormatter.date(from: dateStr)
        return date
    }

    @objc func datePickChanged(){
     //   let ticket = TicketStub(context: self.moc)
//       // let dateFormatter = DateFormatter.localizedString(from: self.datePicker.date, dateStyle: .long, timeStyle: .short) //時間樣式
//        self.datePicker.date
//        self.currentDate = dateFormatter
        print(nowDate)

    }
    @IBAction func changeMapPlace(_ sender: Any) {
        
    }
    @objc func cancel(){
          dismiss(animated: true, completion: nil)
      }
   @objc func done() {
    
    let ticket : TicketStub
    if currentTicket != nil {
        ticket = currentTicket!
    }else {
        ticket = TicketStub(context: self.moc)
    }
    ticket.title = self.textField.text
    ticket.date = DateFormatter.localizedString(from: self.datePicker.date, dateStyle: .long, timeStyle: .short) //時間樣式
    ticket.contentText = self.textView.text
    
    if let image = self.imageV.image, self.isNewImage {
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
    }
    
    self.delegate?.didupdateView(ticketStub: ticket)
    if self.currentTicket == nil {
        self.dismiss(animated: true, completion: nil)
    }else {
        self.navigationController?.popViewController(animated: true)
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

