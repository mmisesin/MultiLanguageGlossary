//
//  LookupViewController.swift
//  MultiLanguageGlossary
//
//  Created by Artem Misesin on 4/14/18.
//  Copyright © 2018 misesin. All rights reserved.
//

import UIKit
import RealmSwift
import SVProgressHUD

class LookupViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchString: String?
    
    private let translator = Translator()
    private let dictionaryService = DictionaryService()
    
    lazy var translations = try! Realm().objects(TranslationObject.self).sorted(byKeyPath: "date", ascending: false)
    
    private var searchTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        self.navigationController?.navigationBar.prefersLargeTitles = true
        setupSearch()
        self.title = "Lookup"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
        searchTimer?.invalidate()
        searchController.searchBar.resignFirstResponder()
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: false)
        }
    }
    
}

// MARK: - Private methods

extension LookupViewController {
    
    private func setupSearch() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.placeholder = "Enter a word"
        self.navigationItem.searchController = searchController
        resetSearchTimer()
    }
    
    private func resetSearchTimer() {
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            if self.searchString != "" {
                self.translate()
            }
        }
    }
    
    private func translate() {
        guard let text = searchString else {
            return
        }
        SVProgressHUD.show()
        let realm = try! Realm()
        translator.translate(text, source: nil) { (result, error) in
            guard error == nil,
                let result = result
                else {
                    print(error!.localizedDescription)
                    return
            }
            guard
                let data = result.data
                else {
                    return
            }
            SVProgressHUD.dismiss()
            self.searchTimer?.invalidate()
            DispatchQueue.main.async {
                try! realm.write {
                    let newObject = TranslationObject()
                    newObject.word = data.translations.first?.translatedText?.lowercased().replacingOccurrences(of: "a ", with: "") ?? "Unknown"
                    newObject.sourceLanguage = data.translations.first?.detectedSourceLanguage ?? "en"
                    newObject.date = Date()
                    realm.add(newObject)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    private func lookup(word: String, completion: @escaping (DefinitionObject) -> Void) {
        let wantedWord = word.lowercased().replacingOccurrences(of: "a ", with: "")
        let realm = try! Realm()
        if let definition = realm.object(ofType: DefinitionObject.self, forPrimaryKey: wantedWord) {
            completion(definition)
        } else {
            SVProgressHUD.show()
            self.dictionaryService.getDefinition(for: wantedWord) { (definitionResult, definitionError) in
                guard
                    definitionError == nil,
                    let definitionResult = definitionResult
                    else {
                        print(definitionError!.localizedDescription)
                        return
                }
                SVProgressHUD.dismiss()
                DispatchQueue.main.async {
                    try! realm.write {
                        let newObject = DefinitionObject(from: definitionResult)
                        realm.add(newObject)
                        completion(newObject)
                    }
                    
                }
            }
        }
    }
    
    
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension LookupViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return translations.count < 20 ? translations.count : 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "lookupWordCell", for: indexPath) as? WordTableViewCell {
            cell.viewModel = WordTableViewCell.ViewModel(translation: translations[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "DefinitionsVC") as? DefinitionsViewController {
            let word = translations[indexPath.row].word
            lookup(word: word) { object in
                vc.definition = object
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
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
        searchString = searchController.searchBar.text
    }
    
}

extension LookupViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.translate()
    }
    
}
