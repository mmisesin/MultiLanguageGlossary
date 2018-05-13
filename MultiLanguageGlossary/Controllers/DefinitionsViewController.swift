//
//  DefinitionsViewController.swift
//  MultiLanguageGlossary
//
//  Created by Artem Misesin on 5/7/18.
//  Copyright © 2018 misesin. All rights reserved.
//

import UIKit

class DefinitionsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchString: String?
    
    var definition = DefinitionObject() {
        didSet {
            DispatchQueue.main.async {
                self.navigationItem.title = self.definition.word
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: false)
        }
    }
    
}

extension DefinitionsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return definition.lexicalEntries.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return definition.lexicalEntries[section].lexicalCategory
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return definition.lexicalEntries[section].entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "definitionCell", for: indexPath)
        cell.textLabel?.text = definition.lexicalEntries[indexPath.section].entries[indexPath.row].definition
        cell.detailTextLabel?.text = definition.lexicalEntries[indexPath.section].entries[indexPath.row].domainName
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "DefinitionDetailVC") as? DefinitionDetailViewController {
            vc.definition = definition.lexicalEntries[indexPath.section].entries[indexPath.row]
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}
