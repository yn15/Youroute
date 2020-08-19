//
//  TravelListController.swift
//  Gallery
//
//  Created by CY on 2020/07/08.
//  Copyright © 2020 CY. All rights reserved.
//

import UIKit

class TravelController: UIViewController {

    let images = [ "test.jpeg", "1.jpg" , "2.jpg", "3.jpg", "4.jpg", "5.jpg", "test2.jpeg" ]
    
    var filtered : [String] = []
    var searchActive : Bool = false
    let searchController = UISearchController(searchResultsController: nil)
    
    private var didTapDeleteKey = false
    
    //@IBOutlet weak var TravelSearchbar: UISearchBar!
    @IBOutlet weak var TravelCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*TravelSearchbar.delegate = self
        TravelSearchbar.placeholder = "Search Country"
        
        automaticallyAdjustsScrollViewInsets = false
        definesPresentationContext = true
        
        TravelSearchbar.showsCancelButton = true
        */
        TravelCollectionView.delegate = self
        TravelCollectionView.dataSource = self

    }
    


}

extension TravelController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout /*,UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating*/ {
    /*
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = TravelSearchbar.text
        filtered = images.filter({ (image) -> Bool in
            let countryText: NSString = image as NSString
            
            return (countryText.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        })
        
        TravelCollectionView.reloadData()
    }
 */
    
    /*
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.dismiss(animated: true, completion: nil)
        print("11111")
               let searchString = TravelSearchbar.text
               filtered = images.filter({ (image) -> Bool in
                   let countryText: NSString = image as NSString
                   
                   return (countryText.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
               })
               
               TravelCollectionView.reloadData()

        
    }
 */
    /*
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        TravelCollectionView.reloadData()
        
    }
    */
    
    /*
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        print("11111")
        let searchString = TravelSearchbar.text
        filtered = images.filter({ (image) -> Bool in
            let countryText: NSString = image as NSString
            
            return (countryText.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        })
        
        TravelCollectionView.reloadData()

    }
 */
    
    /*
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        if !searchActive {
            searchActive = true
            TravelCollectionView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    */
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
        
        /*
        if searchActive {
            return filtered.count
        }
        else
        {
        return images.count
        }
 */

    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 374, height: 128)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = TravelCollectionView.dequeueReusableCell(withReuseIdentifier: "Travelcheck", for: indexPath) as? TravelSubCell
    
        cell?.Travelimage.image = UIImage(named: images[indexPath.row])
        cell?.Travellabel.text = images[indexPath.row]
        cell?.Travelimage.alpha = 0.5
        cell?.Travelimage.layer.cornerRadius = 30
        return cell!
        /*
        if searchActive {
            cell?.Travelimage.image = UIImage(named: filtered[indexPath.row])
            cell?.Travellabel.text = filtered[indexPath.row]
            cell?.Travelimage.alpha = 0.5
            cell?.Travelimage.layer.cornerRadius = 30
            return cell!


        } else {
            cell?.Travelimage.image = UIImage(named: images[indexPath.row])
            cell?.Travellabel.text = images[indexPath.row]
            cell?.Travelimage.alpha = 0.5
            cell?.Travelimage.layer.cornerRadius = 30
            return cell!
        }
 */
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyBoard = self.storyboard!
        let move = storyBoard.instantiateViewController(withIdentifier: "DetailController") as! DetailController
        
        move.rcvlabel = images[indexPath.row]
        self.navigationController?.pushViewController(move, animated: true)
        
    }
    
    
}
