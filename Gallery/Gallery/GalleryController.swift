import UIKit
import Firebase
import FirebaseUI
import FirebaseStorage
import FirebaseFirestoreSwift

class GalleryController: UIViewController {

    var images : [String] = []
    let fireref = Firestore.firestore()
    let storage = Storage.storage()
    
    @IBOutlet weak var GallerySearchBar: UISearchBar!
    
    @IBOutlet weak var GalleryCollectionView: UICollectionView!
    
    
    @IBAction func GoSearch(_ sender: UIButton) {
        if let searchcontroller = self.storyboard?.instantiateViewController(identifier: "SearchController") {
            self.navigationController?.pushViewController(searchcontroller, animated: true)
        }
    }
    
    func test() {
        storage.reference().child("images").listAll { (result, error) in
            if let error = error {
                print(error)
            }
            for item in result.items {
                self.images.append(item.name)
                }
            self.GalleryCollectionView.reloadData()
            }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        test()
    }
}

extension GalleryController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if let searchcontroller = self.storyboard?.instantiateViewController(identifier: "SearchController"){
            self.navigationController?.pushViewController(searchcontroller, animated: true)
        }
        self.GallerySearchBar.resignFirstResponder()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = GalleryCollectionView.dequeueReusableCell(withReuseIdentifier: "Gallerycheck", for: indexPath) as? GallerySubCell
        
        self.storage.reference(forURL: "gs://youroutehknu.appspot.com/images/" + images[indexPath.row]).downloadURL { (url, error) in
                    let data = NSData(contentsOf: url!)
                    let image = UIImage(data: data! as Data)
            print(self.images[indexPath.row])
        cell?.GalleryImage.image = image
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyBoard = self.storyboard!
        let move = storyBoard.instantiateViewController(withIdentifier: "StoryController") as! StoryController
        
        move.rcvimage = UIImage(named: images[indexPath.row])
        self.navigationController?.pushViewController(move, animated: true)
        
    }
    
    
}
