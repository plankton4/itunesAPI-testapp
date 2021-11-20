//
//  ViewController.swift
//  iTunesAlbums
//
//  Created by Dmitry Iv on 17.11.2021.
//

/**
 * First page (Search)
 */

import UIKit

class SearchViewController: UIViewController {
    
    var albumsViewController: AlbumsViewController!
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for music albums"
        searchController.searchBar.searchBarStyle = .default
        searchController.obscuresBackgroundDuringPresentation = false
        
        return searchController
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmbedCollectionViewInSearch" {
            if let vc = segue.destination as? AlbumsViewController {
                albumsViewController = vc
            }
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard !searchBar.text!.isEmpty else {
            return
        }
        
        albumsViewController.performSearch(text: searchBar.text!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        Searcher.shared.cancelSearch()
        albumsViewController.hideActivityIndicator()
    }
}
