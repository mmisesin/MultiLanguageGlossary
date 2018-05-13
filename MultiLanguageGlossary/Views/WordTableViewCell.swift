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
            languageLabel.text = viewModel.language
        }
    }
    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

extension WordTableViewCell {

    struct ViewModel {
        let word: String
        let language: String
    }
    
}

extension WordTableViewCell.ViewModel {
    
    init() {
        word = ""
        language = ""
    }
    
    init(translation: TranslationObject) {
        word = translation.word
        language = translation.sourceLanguage
    }
}
