//
//  ScrollViewController.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/7/22.
//

import UIKit

class ScrollViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var textLabel: [UILabel]!
    @IBOutlet weak var textField: UITextField!
    var currentData = PickerData()
    var firstVC : FirstViewController?
    var textTitle = ["主題：", "日期：", "標籤：", "備註："]
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
        // dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //顯示的日期時間格式
        
        datePicker.addTarget(self, action: #selector(datePickChanged), for: .valueChanged)
        
        imageV.image = self.currentData.image
        scrollView.contentSize = CGSize(width: 384, height: 1000)
       
        self.contentView.layer.cornerRadius = 20
     /*
        contentView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor, constant: 10).isActive = true
        contentView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor, constant: 10).isActive = true
        contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 10).isActive = true
        
        scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10).isActive = true
        scrollView.contentLayoutGuide.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        scrollView.contentLayoutGuide.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        scrollView.contentLayoutGuide.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 10).isActive = true
        
    //    contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 10).isActive = true
        
        */
    }
    
    @objc func datePickChanged(){
        let dateFormatter = DateFormatter.localizedString(from: self.datePicker.date, dateStyle: .long, timeStyle: .short) //時間樣式
        self.currentData.date = dateFormatter
        print(self.currentData.date!)

    }
    @IBAction func changeMapPlace(_ sender: Any) {
        
    }
    @IBAction func done(_ sender: Any) {
        
        currentData.image = self.imageV.image
        if let firstVC = storyboard?.instantiateViewController(withIdentifier: "firstVC") as? FirstViewController {
           firstVC.didupdateCollectionView(pickerData: currentData)
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
//MARK : UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // 收鍵盤
        self.currentData.title = textField.text
        print(textField.text!)
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
