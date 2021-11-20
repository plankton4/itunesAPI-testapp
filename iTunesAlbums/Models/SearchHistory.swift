//
//  SearchHistory.swift
//  iTunesAlbums
//
//  Created by Dmitry Iv on 20.11.2021.
//

/**
 * SearchHistory is class for storing, saving and loading history of search,
 * primarily is used as a model for HistoryViewController
 */

import Foundation

class SearchHistory {
    
    static let shared = SearchHistory()
    let searchHistoryKey = "searchHistory"
    var history: [String] = []
    let historyUpdatedNotification = Notification.Name(rawValue: "HistoryUpdatedNotification")
    
    
    private init() {
        history = UserDefaults.standard.stringArray(forKey: searchHistoryKey) ?? []
    }
    
    func updateHistory(text: String) {
        if !history.isEmpty && history.first! == text {
            // we do not need the same search strings
            return
        }
        
        history.insert(text, at: 0)
        if history.count > 20 {
            history.removeLast()
        }
        UserDefaults.standard.set(history, forKey: searchHistoryKey)
        NotificationCenter.default.post(name: historyUpdatedNotification, object: nil)
    }
}
