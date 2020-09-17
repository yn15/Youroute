//
//  DetailListController.swift
//  Gallery
//
//  Created by CY on 2020/07/08.
//  Copyright © 2020 CY. All rights reserved.
//

import UIKit

class DetailController: UIViewController {

    var rcvlabel: String?
    
    @IBOutlet weak var DetailMainLabel: UILabel!
    @IBOutlet weak var DetailCollectionView: UICollectionView!
    
    var string = ""
    
    let images = [ "test.jpeg", "1.jpg" , "2.jpg", "3.jpg", "4.jpg", "5.jpg", "test2.jpeg" ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DetailMainLabel.text = rcvlabel

        // Do any additional setup after loading the view.
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

extension DetailController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let images = [ "test.jpeg", "1.jpg" , "2.jpg", "3.jpg", "4.jpg", "5.jpg", "test2.jpeg" ]
        
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 374, height: 128)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = DetailCollectionView.dequeueReusableCell(withReuseIdentifier: "Detailcheck", for: indexPath) as? DetailSubCell
        
        cell?.DetailImage.image = UIImage(named: images[indexPath.row])
        
        if let index = images[indexPath.row].range(of: ".")?.lowerBound {
            let substring = images[indexPath.row][..<index]
            string = String(substring)
        }//확장자 제거
        
        cell?.DetailLabel.text = string
        cell?.DetailImage.alpha = 0.5
        
        cell?.DetailImage.layer.cornerRadius = 30
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyBoard = self.storyboard!
        let move = storyBoard.instantiateViewController(withIdentifier: "MapController") as! MapController
        
        self.navigationController?.pushViewController(move, animated: true)
        
    }
    
    
}
