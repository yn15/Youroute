//
//  TravelListController.swift
//  Gallery
//
//  Created by CY on 2020/07/08.
//  Copyright © 2020 CY. All rights reserved.
//

import UIKit

class TravelController: UIViewController {
    let images = [ "test.jpeg", "괌.jpeg" , "독일.jpeg", "부산.jpeg", "제주도.jpeg", "test2.jpeg" ]
    let imagesn = [ "test", "괌" , "독일", "부산", "제주도", "test2" ]
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
        

    }
    


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
