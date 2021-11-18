//
//  ViewController.swift
//  iTunesAlbums
//
//  Created by Dmitry Iv on 17.11.2021.
//

import UIKit

class SearchViewController: UIViewController {
    
    var collectionVC: UIViewController!
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for music albums"
        searchController.searchBar.searchBarStyle = .default
        return searchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("View did load")
        setupView()
    }
    
    func setupView() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmbedCollectionViewInSearch" {
            if let vc = segue.destination as? AlbumsViewController {
                print("Found AlbumsCollectionVC in SearchVC!")
                self.collectionVC = vc
            }
        }
    }

}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search clicked")
    }
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        print("Search updating \(searchController.searchBar.text!)")
    }
}
