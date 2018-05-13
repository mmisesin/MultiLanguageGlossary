//
//  DefinitionDetailViewController.swift
//  MultiLanguageGlossary
//
//  Created by Artem Misesin on 5/8/18.
//  Copyright © 2018 misesin. All rights reserved.
//

import UIKit

class DefinitionDetailViewController: UIViewController {
    
    @IBOutlet weak var definitionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var etymologyLabel: UILabel!
    
    private var viewIsLoaded = false
    
    var definition: Definition? {
        didSet {
            self.updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        self.tableView.reloadData()
        viewIsLoaded = true
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: false)
        }
    }
    
    private func updateUI() {
        if viewIsLoaded {
            DispatchQueue.main.async {
                self.navigationItem.title = self.definition?.word
                self.definitionLabel.text = self.definition?.definition ?? "No definition found"
                self.etymologyLabel.text = self.definition?.etymology ?? "No etymology found"
            }
        }
    }
    
}

extension DefinitionDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return definition?.examples.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "definitionExampleCell", for: indexPath)
        cell.textLabel?.text = definition?.examples[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}
