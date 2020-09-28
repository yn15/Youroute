//
//  TravelListController.swift
//  Gallery
//
//  Created by CY on 2020/07/08.
//  Copyright © 2020 CY. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import FirebaseStorage
import FirebaseFirestoreSwift

//struct Country {
//    
//    var name : String
//    
//    init(snapshot: QueryDocumentSnapshot) {
//        
//        name = snapshot.documentID
//        
//    }
//    
//}

class TravelController: UIViewController {
    //var images = [ "test.jpeg", "괌.jpeg" , "독일.jpeg", "부산.jpeg", "제주도.jpeg", "test2.jpeg" ]
    private var country = [Country]()
    
    var images : [String] = []
    
    //var list:[Country] = []
    
    let fireref = Firestore.firestore()
    
    var string = ""
    var filtered : [String] = []
    var searchActive : Bool = false
    let searchController = UISearchController(searchResultsController: nil)
    
    private var didTapDeleteKey = false
    
    //var country : [String] = []
    
    
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
        
//        test(){ value in
//
//            self.images = value
//            print(self.images)
//
//        self.TravelCollectionView.reloadData()
//
//        }
//        let a = red()
//        print(a)
        //test()
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        fireref.collection("travel").getDocuments() { (snapshot, err) in
//                        if let err = err {
//                            print("Error getting documents: \(err)")
//                        } else {
//                            guard let snap = snapshot else { return }
//                            for document in snap.documents {
//                                let name = document.documentID
//                                Country.init(name: name)
//                                let newcou = Country(name: name)
//                                self.country.append(newcou)
//                            }
//                            self.TravelCollectionView.reloadData()
//                        }
//                }
//    }
    
    
//    func test(completionHandler: @escaping ([String]) -> Void) {
//        fireref.collection("travel").getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                //var country : [String] = []
//                for document in querySnapshot!.documents {
//                    //print(document.documentID)
//                    self.images.append(document.documentID)
//
//                }
//                completionHandler(self.images)
//            }
//        }
//    }
    
//    func red() -> ListenerRegistration {
//        fireref.collection("travel").addSnapshotListener { (querySnapshot, error) in
//            guard let documents = querySnapshot?.documents else {
//                print("error")
//                return
//            }
//
//            self.cc = documents.compactMap({ (queryDocumentSnapshot) -> Country? in
//                let data = queryDocumentSnapshot.documentID
//                //print(data)
//                //print(Country.init(snapshot: queryDocumentSnapshot))
//                //print(type(of: Country.init(snapshot: queryDocumentSnapshot)))
//                Country.init(snapshot: queryDocumentSnapshot)
//
//                return Country.init(snapshot: queryDocumentSnapshot)
//            })
//            }
//    }
    
 
    
//    func test() {
//        fireref.collection("travel").getDocuments() { (snapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    for document in snapshot!.documents {
//                        if let name = document.documentID as? String {
//                        }
//                    }
//
//                }
//        }
//    }
    
    
    
}

extension TravelController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
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
               
        self.TravelCollectionView.reloadData()

        
    }
     
  
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        let searchString = TravelSearchbar.text
        filtered = images.filter({ (image) -> Bool in
            let countryText: NSString = image as NSString
            
            return (countryText.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        })
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
            //TravelCollectionView.reloadData()
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
        
        if let index = images[indexPath.row].range(of: ".")?.lowerBound {
            let substring = images[indexPath.row][..<index]
            string = String(substring)
        } // 확장자 제거
        
        
        if searchActive {
            cell?.Travelimage.image = UIImage(named: filtered[indexPath.row])
            if let index = filtered[indexPath.row].range(of: ".")?.lowerBound {
                let substring = filtered[indexPath.row][..<index]
                string = String(substring)
            }
            cell?.Travellabel.text = string
            cell?.Travelimage.alpha = 0.5
            cell?.Travelimage.layer.cornerRadius = 30
            return cell!
        } else {
            cell?.Travelimage.image = UIImage(named: images[indexPath.row])
            cell?.Travellabel.text = string
            cell?.Travelimage.alpha = 0.5
            cell?.Travelimage.layer.cornerRadius = 30
            return cell!
        }
        
 
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyBoard = self.storyboard!
        let move = storyBoard.instantiateViewController(withIdentifier: "DetailController") as! DetailController
        
        if let index = images[indexPath.row].range(of: ".")?.lowerBound {
            let substring = images[indexPath.row][..<index]
            string = String(substring)
        }//확장자 제거
        
        
        if searchActive {
            if let index = filtered[indexPath.row].range(of: ".")?.lowerBound {
                let substring = filtered[indexPath.row][..<index]
                string = String(substring)
            }//확장자 제거
            move.rcvlabel = string
            self.navigationController?.pushViewController(move, animated: true)
        } else {
            move.rcvlabel = string
            self.navigationController?.pushViewController(move, animated: true)
        }
        
        
        
    }
    



}


