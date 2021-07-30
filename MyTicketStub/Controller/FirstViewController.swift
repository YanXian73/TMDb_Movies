//
//  ViewController.swift
//  MyTicketStub
//
//  Created by 吳彥賢 on 2021/7/20.
//

import UIKit

class FirstViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate, ScrollViewControllerDeleage {
    func didupdateView( pickerData: PickerData){
        data.append(pickerData)
        
        self.collectionView.reloadData()
    }
    
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // var collectionView = UICollectionView()
    
    let picker = UIImagePickerController()
    
    var text = ["青檸雷夢.jpg"]
    
    var data = [PickerData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
//        let fullScreenSize = UIScreen.main.bounds.size
//        self.collectionView = UICollectionView(frame: CGRect(
//              x: 0, y: 20,
//              width: fullScreenSize.width,
//              height: fullScreenSize.height - 20),
//            collectionViewLayout: collectionLayout)
    //   collectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
       /*
        func didupdateView( pickerData: PickerData){
            data.append(pickerData)
            
            self.collectionView.reloadData()
        }*/
    }
    
    //test
    @IBAction func goToScrollView(_ sender: Any) {
        if let scrollVC = storyboard?.instantiateViewController(withIdentifier: "scrollVC") as? ScrollViewController {
           
            self.navigationController?.pushViewController(scrollVC, animated: true)
        }
        
    }
    
    @IBAction func camera(_ sender: Any) {
        
        picker.sourceType = .savedPhotosAlbum
      //  picker.sourceType = .camera
        self.present(picker, animated: true, completion: nil)
        picker.delegate = self
    }
    
//MARK:UIImagePickerControllerDelegate & UINavigationControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage ,
           let scrollVC = storyboard?.instantiateViewController(withIdentifier: "scrollVC") as? ScrollViewController {
          //  UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil) //存到相簿裡
            scrollVC.delegate = self
            scrollVC.currentData.image = image
            self.dismiss(animated: true, completion:nil) //關閉拍照選擇視窗
            present(scrollVC, animated: true, completion: nil)
          //  self.navigationController?.pushViewController(scrollVC, animated: true)
        
        }
    //    if let scVC = storyboard?.instantiateViewController(withIdentifier: "secondVC") as? SecondViewController {
      //  }
      //  collectionView.reloadInputViews()
    }
    
    
    //MARK:UICollectionViewDataSource, UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCollectionViewCell
        //  cell.textLabel.text = text[indexPath.row]
        cell.image.image = self.data[indexPath.row].image
//        self.collectionLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 20)
//        self.collectionLayout.minimumLineSpacing = 5 //設定cell與cell間的縱距
        
        return cell
    }
    
    
}

