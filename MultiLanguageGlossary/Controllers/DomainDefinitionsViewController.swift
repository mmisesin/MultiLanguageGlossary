//
//  DomainDefinitionsViewController.swift
//  MultiLanguageGlossary
//
//  Created by Artem Misesin on 5/6/18.
//  Copyright © 2018 misesin. All rights reserved.
//

import UIKit
import RealmSwift

class DomainDefinitionsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchString = ""
    
    var domainName = ""
    
    let realm = try! Realm()
    lazy var definitions = try! Realm().objects(Definition.self).filter("domainName = '\(self.domainName)'").sorted(byKeyPath: "word")
    lazy var filteredResults = definitions.filter("word CONTAINS '\(self.searchString)'").sorted(byKeyPath: "word")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: false)
        }
        self.title = domainName
    }
    
    private func setupSearch() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.placeholder = "Enter a word"
        self.navigationItem.searchController = searchController
    }
    
}

extension DomainDefinitionsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredResults.count
        } else {
            return definitions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "glossaryWordCell", for: indexPath)
        if isSearching {
            cell.textLabel?.text = filteredResults[indexPath.row].word
            cell.detailTextLabel?.text = filteredResults[indexPath.row].definition
        } else {
            cell.textLabel?.text = definitions[indexPath.row].word
            cell.detailTextLabel?.text = definitions[indexPath.row].definition
        }
        return cell
    }
    
}

// MARK: - UISearchResultsUpdating

extension DomainDefinitionsViewController: UISearchResultsUpdating {
    
    var searchBarIsEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isSearching: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        searchString = searchController.searchBar.text ?? ""
        filteredResults = definitions.filter("word CONTAINS '\(searchString)'").sorted(byKeyPath: "word")
        tableView.reloadData()
    }
    
}
