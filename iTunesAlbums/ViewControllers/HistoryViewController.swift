//
//  HistoryVC.swift
//  iTunesAlbums
//
//  Created by Dmitry Iv on 18.11.2021.
//

/**
 * Second page (History)
 */

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var dummyLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        listenForHistoryUpdates()
        if SearchHistory.shared.history.isEmpty {
            showDummy()
        }
    }
    
    func listenForHistoryUpdates() {
        NotificationCenter.default.addObserver(
            forName: SearchHistory.shared.historyUpdatedNotification,
            object: nil,
            queue: OperationQueue.main) { [weak self] _ in
                if let weakSelf = self {
                    weakSelf.tableView.reloadData()
                    if weakSelf.dummyLabel != nil {
                        weakSelf.hideDummy()
                    }
                }
            }
    }
    
    func showDummy() {
        tableView.isHidden = true
        
        dummyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        dummyLabel!.center = view.center
        dummyLabel!.textAlignment = .center
        dummyLabel!.text = "Empty"
        dummyLabel!.textColor = UIColor(named: "ArtistName")
        dummyLabel!.font = UIFont.systemFont(ofSize: 40, weight: .regular)
        view.addSubview(dummyLabel!)
    }
    
    func hideDummy() {
        dummyLabel?.removeFromSuperview()
        dummyLabel = nil
        tableView.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AlbumsViewFromHistory" {
            if let vc = segue.destination as? AlbumsViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    vc.searchString = SearchHistory.shared.history[indexPath.row]
                }
            }
        }
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchHistory.shared.history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {
            fatalError("Unable to dequeue 'Cell'")
        }
        cell.textLabel?.text = SearchHistory.shared.history[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
