//
//  SearchController.swift
//  Gallery
//
//  Created by CY on 2020/05/19.
//  Copyright © 2020 CY. All rights reserved.
//

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
    //var searchActive : Bool = false
    
    
    @IBOutlet weak var Searchbar: UISearchBar!
    @IBOutlet weak var SearchCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
//        let searchString = Searchbar.text
//        filtered = images.filter({ (image) -> Bool in
//            let countryText: NSString = image as NSString
//            return (countryText.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
//        })
        self.SearchCollectionView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //searchActive = false
//        self.dismiss(animated: true, completion: nil)
//               let searchString = Searchbar.text
//               filtered = images.filter({ (image) -> Bool in
//                   let countryText: NSString = image as NSString
//
//                   return (countryText.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
//               })
        filtered = []
        self.Searchbar.text = ""
        self.Searchbar.resignFirstResponder()
               
        self.SearchCollectionView.reloadData()

        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        images = Searchbar.text!
//        filtered = images.filter({ (image) -> Bool in
//            let countryText: NSString = image as NSString
//
//            return (countryText.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
//        })
        
        
        
        self.SearchCollectionView.reloadData()

    }
    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//             searchActive = true
//             self.SearchCollectionView.reloadData()
//         }
//
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        searchActive = false;
//        self.SearchCollectionView.reloadData()
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return filtered.count
        
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        let storyBoard = self.storyboard!
        let move = storyBoard.instantiateViewController(withIdentifier: "StoryController") as! StoryController
            
            move.rcvimage = UIImage(named: filtered[indexPath.row])
            self.dismiss(animated: true, completion: nil)
//            let searchString = Searchbar.text
        
//            filtered = images.filter({ (image) -> Bool in
//                let countryText: NSString = image as NSString
//
//                return (countryText.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
//                })
            self.navigationController?.pushViewController(move, animated: true)
                
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 374, height: 128)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = SearchCollectionView.dequeueReusableCell(withReuseIdentifier: "Searchcheck", for: indexPath) as? SearchSubCell
        
        fireref.collection(images).document(images).addSnapshotListener { (documentSnapshot, error) in
                    guard let document = documentSnapshot else {
                        print("error")
                        return
                    }
                    let Ary = (document.get("picture") as! Array<Any>)
                    self.storage.reference(forURL: Ary[0] as! String).downloadURL { (url, error) in
                        let data = NSData(contentsOf: url!)
                        let image = UIImage(data: data! as Data)
                        cell?.SearchImage.image = image
                        }
                    }
            cell?.SearchImage.alpha = 0.5
            cell?.SearchImage.layer.cornerRadius = 30
            return cell!
        
    }
    
    
    
}
