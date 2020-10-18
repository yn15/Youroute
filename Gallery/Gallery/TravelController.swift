import UIKit
import Firebase
import FirebaseUI
import FirebaseStorage
import FirebaseFirestoreSwift

class TravelController: UIViewController {
    
    var images : [String] = []
    var imgg : [String] = []
    
    let fireref = Firestore.firestore()
    let storage = Storage.storage()
    var string = ""
    var filtered : [String] = []
    var searchActive : Bool = false
    let searchController = UISearchController(searchResultsController: nil)
    
    private var didTapDeleteKey = false
    
    @IBOutlet weak var TravelSearchbar: UISearchBar!
    @IBOutlet weak var TravelCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        TravelCollectionView.delegate = self
        TravelCollectionView.dataSource = self
        
        TravelSearchbar.delegate = self
        TravelSearchbar.placeholder = "Search Country"
        
        automaticallyAdjustsScrollViewInsets = false
        definesPresentationContext = true
        
        TravelSearchbar.showsCancelButton = true
        test()
        
    }
    
    func test() {
        
        fireref.collection("travel").document("travel").addSnapshotListener { (documentSnapshot, error) in
            guard let document = documentSnapshot else {
                print("error")
                return
            }
            
            let Ary = (document.get("Country") as! Array<Any>)
            for Arys in Ary {
                self.images.append(Arys as! String)
            }
            self.TravelCollectionView.reloadData()
        }
        
    }
    
}

extension TravelController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }

    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = TravelSearchbar.text
        filtered = images.filter({ (image) -> Bool in
            let countryText: NSString = image as NSString
            return (countryText.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        })
        self.TravelCollectionView.reloadData()
    }

    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.dismiss(animated: true, completion: nil)
               let searchString = TravelSearchbar.text
               filtered = images.filter({ (image) -> Bool in
                   let countryText: NSString = image as NSString
                   
                   return (countryText.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
               })
        filtered = []
        self.TravelSearchbar.text = ""
        self.TravelSearchbar.resignFirstResponder()
               
        self.TravelCollectionView.reloadData()

        
    }
     
  
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        let searchString = TravelSearchbar.text
        filtered = images.filter({ (image) -> Bool in
            let countryText: NSString = image as NSString
            
            return (countryText.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        
        self.TravelCollectionView.reloadData()

    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
          searchActive = true
          self.TravelCollectionView.reloadData()
      }
 
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        self.TravelCollectionView.reloadData()
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        if !searchActive {
            searchActive = true
        }
        
        searchController.searchBar.resignFirstResponder()
        self.TravelCollectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchActive {
            return filtered.count
        }
        else
        {
        return images.count
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 374, height: 128)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = TravelCollectionView.dequeueReusableCell(withReuseIdentifier: "Travelcheck", for: indexPath) as? TravelSubCell

        if searchActive == true {
            fireref.collection(filtered[indexPath.row]).document(filtered[indexPath.row]).addSnapshotListener { (documentSnapshot, error) in
                            guard let document = documentSnapshot else {
                                print("error")
                                return
                            }
                            let Ary = (document.get("DAY-1") as! Array<Any>)
                self.storage.reference(forURL: Ary[0] as! String).downloadURL { (url, error) in
                                    let data = NSData(contentsOf: url!)
                                    let image = UIImage(data: data! as Data)
                                cell?.Travelimage.image = image
                                        }
                        }
            
            cell?.Travellabel.text = filtered[indexPath.row]
            cell?.Travelimage.alpha = 0.5
            cell?.Travelimage.layer.cornerRadius = 30
            return cell!
        } else if searchActive == false {
            fireref.collection(images[indexPath.row]).document(images[indexPath.row]).addSnapshotListener { (documentSnapshot, error) in
                guard let document = documentSnapshot else {
                    print("error")
                    return
                }
                let Ary = (document.get("DAY-1") as! Array<Any>)
                self.storage.reference(forURL: Ary[0] as! String).downloadURL { (url, error) in
                        let data = NSData(contentsOf: url!)
                        let image = UIImage(data: data! as Data)
                    cell?.Travelimage.image = image
                            }
            }
            
            cell?.Travellabel.text = images[indexPath.row]
            cell?.Travelimage.alpha = 0.5
            cell?.Travelimage.layer.cornerRadius = 30
            return cell!
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyBoard = self.storyboard!
        let move = storyBoard.instantiateViewController(withIdentifier: "DetailController") as! DetailController
        
        if searchActive {
            move.rcvlabel = filtered[indexPath.row]
            self.dismiss(animated: true, completion: nil)
            let searchString = TravelSearchbar.text
            filtered = images.filter({ (image) -> Bool in
                let countryText: NSString = image as NSString
                
                return (countryText.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
            })
            self.navigationController?.pushViewController(move, animated: true)
        } else {
            move.rcvlabel = images[indexPath.row]
            self.navigationController?.pushViewController(move, animated: true)
        }
    }
}


