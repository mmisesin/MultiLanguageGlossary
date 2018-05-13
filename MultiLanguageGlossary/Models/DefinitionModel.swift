//
//  DefinitionModel.swift
//  MultiLanguageGlossary
//
//  Created by Artem Misesin on 4/16/18.
//  Copyright © 2018 misesin. All rights reserved.
//

import Foundation

struct DefinitionResult: Codable {
    
    struct Metadata: Codable {
        var provider: String?
    }
    
    struct Result: Codable {
        
        struct Note: Codable {
            var id: String?
            var text: String?
            var type: String?
        }
        
        struct GrammaticalFeature: Codable {
            var text: String?
            var type: String?
        }
        
        struct Translation: Codable {
            var domains: [String]?
            var grammaticalFeatures: [GrammaticalFeature]?
            var language: String?
            var notes: [Note]?
            var regions: [String]?
            var registers: [String]?
            var text: String?
        }
        
        struct Example: Codable {
            var definitions: [String]?
            var domains: [String]?
            var notes: [Note]?
            var regions: [String]?
            var registers: [String]?
            var text: String?
            var translations: [Translation]?
        }
        
        struct ThesaurusLink: Codable {
            var entryId: String?
            var senseId: String?
            
            enum CodingKeys: String, CodingKey {
                case entryId = "entry_id"
                case senseId = "sense_id"
            }
        }
        
        struct VariantForm: Codable {
            var regions: [String]?
            var text: String?
        }
        
        struct LexicalEntry: Codable {
            
            struct Derivative: Codable {
                var domains: [String]?
                var id: String?
                var language: String?
                var regions: [String]?
                var registers: [String]?
                var text: String?
            }
            
            struct Entry: Codable {
                
                struct Sense: Codable {
                    
                    var definitions: [String]?
                    var domains: [String]?
                    var examples: [Example]?
                    var id: String?
                    var notes: [Note]?
                    var shortDefinitions: [String]?
                    var subsenses: [Sense]?
                    var thesaurusLinks: [ThesaurusLink]?
                    var translations: [Translation]?
                    var variantForms: [VariantForm]?

                    enum CodingKeys: String, CodingKey {
                        case definitions
                        case domains
                        case examples
                        case id
                        case notes
                        case shortDefinitions = "short_definitions"
                        case subsenses
                        case thesaurusLinks
                        case translations
                        case variantForms
                    }
                    
                }
                
                var etymologies: [String]?
                var grammaticalFeatures: [GrammaticalFeature]?
                var homographNumber: String?
                var notes: [Note]?
                var senses: [Sense]
                var variantForms: [VariantForm]?
                
            }
            
            var derivativeOf: [Derivative]?
            var derivatives: [Derivative]?
            var entries: [Entry]
            var grammaticalFeatures: [GrammaticalFeature]?
            var language: String?
            var lexicalCategory: String?
            var notes: [Note]?
            var text: String?
            var variantForms: [VariantForm]?
            
        }
        
        var id: String?
        var language: String?
        var lexicalEntries: [LexicalEntry]
        var type: String?
        var word: String?
    }
    
    var metadata: Metadata?
    var results: [Result]
    
}
