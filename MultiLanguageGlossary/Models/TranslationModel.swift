//
//  TranslationModel.swift
//  MultiLanguageGlossary
//
//  Created by Artem Misesin on 4/15/18.
//  Copyright © 2018 misesin. All rights reserved.
//

import Foundation

struct Translation: Codable {
    
    struct TranslationData: Codable {
        
        struct Translation: Codable {
            var translatedText: String?
            var detectedSourceLanguage: String?
        }
        
        var translations: [Translation]
    }
    
    var data: TranslationData?
}
