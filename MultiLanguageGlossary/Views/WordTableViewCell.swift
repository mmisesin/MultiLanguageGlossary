//
//  WordTableViewCell.swift
//  MultiLanguageGlossary
//
//  Created by Artem Misesin on 4/15/18.
//  Copyright © 2018 misesin. All rights reserved.
//

import UIKit

class WordTableViewCell: UITableViewCell {
    
    var viewModel: ViewModel = ViewModel() {
        didSet {
            wordLabel.text = viewModel.word
            definitionLabel.text = viewModel.definition
            definitionImage.downloadFrom(link: viewModel.imageUrl)
        }
    }
    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var definitionLabel: UILabel!
    @IBOutlet weak var definitionImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

extension WordTableViewCell {

    struct ViewModel {
        let word: String
        let definition: String
        let imageUrl: String
    }
    
}

extension WordTableViewCell.ViewModel {
    
    init() {
        word = ""
        definition = ""
        imageUrl = ""
    }
    
    init(translation: )
}
