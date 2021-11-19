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
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for music albums"
        searchController.searchBar.searchBarStyle = .default
        searchController.obscuresBackgroundDuringPresentation = false
        
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
                albumsViewController = vc
            }
        }
    }

}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search clicked \(searchBar.text!)")
        Searcher.shared.searchAlbums(searchText: searchBar.text!) { [weak self] success in
            print("Success? \(success), albums count \(MusicData.shared.albums.count)")
            if success && !MusicData.shared.albums.isEmpty {
                self?.albumsViewController.albumsView.reloadData()
            } else {
                Utils.showAlert(title: "Oops!", message: "Nothing found.", firstButtonText: "☹️")
            }
        }
        albumsViewController.albumsView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        Searcher.shared.cancelSearch()
    }
}
