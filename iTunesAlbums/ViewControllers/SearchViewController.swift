//
//  ViewController.swift
//  iTunesAlbums
//
//  Created by Dmitry Iv on 17.11.2021.
//

import UIKit

class SearchViewController: UIViewController {
    
    var albumsViewController: AlbumsViewController!
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for music albums"
        searchController.searchBar.searchBarStyle = .default
        searchController.automaticallyShowsCancelButton = false
        
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
                self.albumsViewController = vc
            }
        }
    }

}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search clicked \(searchBar.text!)")
        Searcher.shared.searchAlbums(searchText: searchBar.text!) { [weak self] success in
            print("Success???????? \(success), albums count \(MusicData.shared.albums.count)")
            if success {
                self?.albumsViewController.albumsView.reloadData()
            }
        }
        albumsViewController.albumsView.reloadData()
        searchController.isActive = false
    }
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        //print("Search updating \(searchController.searchBar.text!)")
    }
}
