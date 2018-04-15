//
//  LookupViewController.swift
//  MultiLanguageGlossary
//
//  Created by Artem Misesin on 4/14/18.
//  Copyright © 2018 misesin. All rights reserved.
//

import UIKit

class LookupViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchString: String?
    
    private let translator = Translator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearch()
    }
    
}

// MARK: - Private methods

extension LookupViewController {
    
    private func setupSearch() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.placeholder = "Enter a word"
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension LookupViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return ParticleHandler.shared.filteredArticlesData(with: self.searchString ?? "").count
        } else {
            return ParticleHandler.shared.loadedArticlesData().count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as? ArticleCellTableViewCell {
            if traitCollection.forceTouchCapability == .available {
                self.registerForPreviewing(with: self, sourceView: tableView)
            }
            let article = getArticleForCell(at: indexPath)
            if isFiltering {
                let range = getSearchRange(at: indexPath)
                cell.configure(with: article, at: indexPath.row, searchStatus: .active(resultRange: range))
            } else {
                cell.configure(with: article, at: indexPath.row, searchStatus: .nonActive)
            }
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
}

// MARK: - UISearchResultsUpdating

extension LookupViewController: UISearchResultsUpdating {
    
    var searchBarIsEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isSearching: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // TODO: search
        print("Searched")
    }

}
