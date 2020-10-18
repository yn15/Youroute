import UIKit
import Firebase
import FirebaseUI
import FirebaseStorage
import FirebaseFirestoreSwift

class SearchController: UIViewController {
    
    var images : String = ""
    let fireref = Firestore.firestore()
    let storage = Storage.storage()
    var filtered : [String] = []
    
    @IBOutlet weak var Searchbar: UISearchBar!
    @IBOutlet weak var SearchCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SearchCollectionView.delegate = self
        SearchCollectionView.dataSource = self
        
        Searchbar.delegate = self
        Searchbar.placeholder = "Search Tag"
        
        automaticallyAdjustsScrollViewInsets = false
        definesPresentationContext = true
        
        Searchbar.showsCancelButton = true
        
    }

    
}

extension SearchController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        self.SearchCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filtered = []
        self.Searchbar.text = ""
        self.Searchbar.resignFirstResponder()
               
        self.SearchCollectionView.reloadData()

        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        images = Searchbar.text!
        fireref.collection(images).document(images).addSnapshotListener { (documentSnapshot, error) in
            guard let document = documentSnapshot else {
                print("error")
                return
            }
            let Ary = (document.get("Picture") as! Array<Any>)
            for Arys in Ary {
                self.filtered.append(Arys as! String)
            }
            self.SearchCollectionView.reloadData()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return filtered.count
        
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        let storyBoard = self.storyboard!
        let move = storyBoard.instantiateViewController(withIdentifier: "StoryController") as! StoryController
            
            move.rcvimage = UIImage(named: filtered[indexPath.row])
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.pushViewController(move, animated: true)
                
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = SearchCollectionView.dequeueReusableCell(withReuseIdentifier: "Searchcheck", for: indexPath) as? SearchSubCell
        
        print(self.filtered[indexPath.row])
        self.storage.reference(forURL: filtered[indexPath.row]).downloadURL { (url, error) in
            let data = NSData(contentsOf: url!)
            let image = UIImage(data: data! as Data)
            cell?.SearchImage.image = image
                        }
            return cell!
        
    }
    
}
