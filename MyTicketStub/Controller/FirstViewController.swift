//
//  ViewController.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/7/20.
//
import CoreData
import UIKit

class FirstViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate, ScrollViewControllerDelegate {
   
    func didupdateView( ticketStub: TicketStub){
        if let index = data.firstIndex(of: ticketStub){
            data[index] = ticketStub
        }else{
            data.append(ticketStub)
        }
      CoreDataHelper.shared.saveContext() //存資料到DB
      self.collectionView.reloadData()
    }
   
    @IBOutlet weak var selectListOutlet: UISegmentedControl!
    @IBOutlet weak var deleteItem: UIBarButtonItem!
    
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
  
    var prepareDeleteItem : [MyCollectionViewCell] = []
    let picker = UIImagePickerController()
    
    var data : [TicketStub]!
    var movieData: MoviesData?
    
    var images = [UIImage]() // test
    
    override func viewDidLoad() {
        super.viewDidLoad()
   //  images.append(UIImage(named: "青檸雷夢.jpg") ?? UIImage())  // test
       self.queryFromDB()
        collectionView.dataSource = self
        collectionView.delegate = self
        self.navigationItem.leftBarButtonItem = editButtonItem
        
    }
  
    @IBAction func deleteBtn(_ sender: Any) {
        let moc = CoreDataHelper.shared.managedObjectContext()
        if isEditing == true {
            
            if  let  selectedCells = collectionView.indexPathsForSelectedItems {
                let  items =  selectedCells.map { $0.item }.sorted() .reversed()
                for item in items {
                    let ticket =  self.data.remove(at: item)
                    moc.performAndWait {
                        moc.delete(ticket)
                    }
                }
                CoreDataHelper.shared.saveContext()
                self.deleteItem.isEnabled = false
                self.collectionView.reloadData()
            }
        }
//            var cell = MyCollectionViewCell()
//         //   var ticket = TicketStub(context: moc)
//            let indexPath = collectionView.indexPathsForVisibleItems
//
//            for index in indexPath {
//                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: index) as! MyCollectionViewCell
//            }
//            if cell.checkMarkLabel.text == "⬤" {
//
//            }
//
        
        
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
       // let cell = MyCollectionViewCell()
        if editing == false {
            self.deleteItem.isEnabled = false
        }
        collectionView.allowsMultipleSelection = editing // 允許多選
        let indexPaths = collectionView.indexPathsForVisibleItems // collectionView 可見的Items 有幾個indexPaths
        for index in indexPaths {
            let cell = collectionView.cellForItem(at: index) as! MyCollectionViewCell
            cell.checkMarkLabel.text = editing ? "⭕" : ""

        }
        //collectionView.beginInteractiveMovementForItem(at: <#T##IndexPath#>)
        
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "segueScrollVC" {
//            if let scrollVC = segue.destination as? ScrollViewController,
//               let index = collectionView.indexPathsForSelectedItems {
//
//            }
//        }
//    }
  
        
    
    //MARK: Core Data
    func queryFromDB()  {
        let moc = CoreDataHelper.shared.managedObjectContext()
        let request = NSFetchRequest<TicketStub>(entityName: "TicketStub")
        moc.performAndWait {
            do{
            let result = try moc.fetch(request)
                self.data = result
            }catch{
                print("error query db \(error)")
                self.data = []
            }
        }
    }
    func saveToDB() {
        
    }
    
    @IBAction func camera(_ sender: Any) {
        if !isEditing {
        picker.sourceType = .savedPhotosAlbum
      //  picker.sourceType = .camera
        self.present(picker, animated: true, completion: nil)
        picker.delegate = self
        }else {
            
        }
    }
    
//MARK:UIImagePickerControllerDelegate & UINavigationControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage ,
           let scrollVC = storyboard?.instantiateViewController(withIdentifier: "scrollVC") as? ScrollViewController {
            //  UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil) //存到相簿裡
            scrollVC.delegate = self
            scrollVC.image = image
            scrollVC.isNewImage = true
            
            let naviC = UINavigationController(rootViewController: scrollVC)
            scrollVC.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: scrollVC, action: #selector(scrollVC.cancel))
            scrollVC.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: scrollVC, action: #selector(scrollVC.done))
            self.dismiss(animated: true, completion:nil) //關閉拍照選擇視窗
            present(naviC, animated: true, completion: nil)
            //  self.navigationController?.pushViewController(scrollVC, animated: true)
        }
    }
   
    //MARK:UICollectionViewDataSource, UICollectionViewDelegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.data.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCollectionViewCell
     //   cell.testimage.image = self.images[indexPath.row] // test
        if !isEditing {
            cell.image.image = self.data[indexPath.row].thumbnailImage()
            cell.checkMarkLabel.text = ""
            
            
        }else{
         //   cell.checkMarkLabel.text = "⭕"
        }
        return cell
        
        
     //   cell.dateLabel.text = self.data[indexPath.row].date
//        self.collectionLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 20)
//        self.collectionLayout.minimumLineSpacing = 5 //設定cell與cell間的縱距
        
    }
    //告訴Delegate被點選到的項目,要執行的動作
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isEditing {
            self.deleteItem.isEnabled = false
            if let scrollVC = storyboard?.instantiateViewController(identifier: "scrollVC") as? ScrollViewController
            {
                scrollVC.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: scrollVC, action: #selector(scrollVC.done))
                scrollVC.image = self.data[indexPath.row].image()!
                scrollVC.currentTicket = self.data[indexPath.row]
                scrollVC.delegate = self
                //                scrollVC.textField.text = self.data[indexPath.row].title
                //                scrollVC.textView.text = self.data[indexPath.row].contentText
                //   scrollVC.datePicker.date = timeStringToDate(self.data[indexPath.row].date)
                self.navigationController?.pushViewController(scrollVC, animated: true)
            }
        }else{
            if let cell = collectionView.cellForItem(at: indexPath) as? MyCollectionViewCell {
                cell.checkMarkLabel.text = "🔴"
                self.prepareDeleteItem.append(cell)
                self.deleteItem.isEnabled = true
            }else{
                self.deleteItem.isEnabled = false
            }
        }
        
    }
    // 告訴Delegate 沒有被選擇的項目
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MyCollectionViewCell
      
        if !isEditing  {
            self.deleteItem.isEnabled = false
            cell.checkMarkLabel.text = ""
        }else {
          self.prepareDeleteItem.removeFirst()
            cell.checkMarkLabel.text = "⭕"
            if self.prepareDeleteItem.count == 0 {
                self.deleteItem.isEnabled = false
            }
        }
    }
//        let items = collectionView.indexPathsForVisibleItems
//        if items.count == 0 {
//            self.deleteItem.isEnabled = false
//            let cell = collectionView.cellForItem(at: indexPath) as! MyCollectionViewCell
//            cell.checkMarkLabel.text = ""
//        }else if isEditing == true ,items.count != 0{
//            self.deleteItem.isEnabled = true
//            let cell = collectionView.cellForItem(at: indexPath) as! MyCollectionViewCell
//            cell.checkMarkLabel.text = "⭕"
//        }
//    }
    
}

