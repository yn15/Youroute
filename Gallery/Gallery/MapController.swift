//
//  MapViewController.swift
//  Gallery
//
//  Created by CY on 2020/07/21.
//  Copyright © 2020 CY. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import FirebaseStorage
import FirebaseFirestoreSwift

class MapController: UIViewController {

    @IBOutlet weak var imageview: UIImageView!
    
    func downloadimage(imageview:UIImageView){
        
        let storage = Storage.storage()
        
        storage.reference(forURL: "gs://youroutehknu.appspot.com/images/test3.jpeg").downloadURL { (url, error) in
                           let data = NSData(contentsOf: url!)
                           let image = UIImage(data: data! as Data)
                            imageview.image = image
            }
    }
    
    func outputroute() -> String {
        
        let testref = Firestore.firestore().collection("test").document("aa")
        
        testref.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()?["bb"] as! String
                print(dataDescription)
                //return dataDescription
            } else {
                print("Document does not exist")
            }
        }
        return ""
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadimage(imageview: imageview)

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
