import UIKit
import Firebase
import FirebaseUI
import FirebaseStorage
import FirebaseFirestoreSwift

class DetailController: UIViewController {

    var rcvlabel: String?
    
    let fireref = Firestore.firestore()
    let storage = Storage.storage()
    
    @IBOutlet weak var DetailMainLabel: UILabel!
    @IBOutlet weak var DetailCollectionView: UICollectionView!
    
    var string = ""
    
    var images : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DetailMainLabel.text = rcvlabel
        test()
    }
    
    func test() {
        
        fireref.collection(rcvlabel!).document(rcvlabel!).addSnapshotListener { (documentSnapshot, error) in
            guard let document = documentSnapshot else {
                print("error")
                return
            }
            
            let Ary = (document.get("DAY") as! Array<Any>)
            
            for Arys in Ary {
                self.images.append(Arys as! String)
                
            }
            self.DetailCollectionView.reloadData()
        }
        
    }

}

extension DetailController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 374, height: 128)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = DetailCollectionView.dequeueReusableCell(withReuseIdentifier: "Detailcheck", for: indexPath) as? DetailSubCell
        
        fireref.collection(rcvlabel!).document(rcvlabel!).addSnapshotListener { (documentSnapshot, error) in
                        guard let document = documentSnapshot else {
                            print("error")
                            return
                        }
            let Ary = (document.get("DAY-\(indexPath.row + 1)") as! Array<Any>)
                self.storage.reference(forURL: Ary[0] as! String).downloadURL { (url, error) in
                    let data = NSData(contentsOf: url!)
                    let image = UIImage(data: data! as Data)
                    cell?.DetailImage.image = image
                    }
                }
        cell?.DetailLabel.text = images[indexPath.row]
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
