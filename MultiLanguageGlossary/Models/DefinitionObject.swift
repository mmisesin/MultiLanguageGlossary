//
//  DefinitionObject.swift
//  MultiLanguageGlossary
//
//  Created by Artem Misesin on 4/21/18.
//  Copyright © 2018 misesin. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class TranslationObject: Object {
    
    @objc dynamic var word = ""
    @objc dynamic var sourceLanguage = ""
    @objc dynamic var date = Date()
    
    override static func primaryKey() -> String? {
        return "word"
    }
    
}

class Domain: Object {
    
    @objc dynamic var name = ""
    var definitions = List<Definition>()
    
    override static func primaryKey() -> String? {
        return "name"
    }
    
    convenience required init(withName name: String) {
        self.init()
        self.name = name
    }
    
}

class DefinitionObject: Object {
    
    @objc dynamic var id = ""
    @objc dynamic var word = ""
    var lexicalEntries = List<LexicalEntry>()
    
    override static func primaryKey() -> String? {
        return "word"
    }
    
//    required init() {
//        super.init()
//        self.id = ""
//        self.word = ""
//        self.lexicalEntries = List<LexicalEntry>()
//    }
    
    convenience required init(from model: DefinitionResult) {
        self.init()
        if
            let result = model.results.first,
            let id = result.id,
            let word = result.word {
            self.id = id
            self.word = word
            for lexicalEntry in result.lexicalEntries {
                let newLexicalEntry = LexicalEntry(from: lexicalEntry, word: word)
                lexicalEntries.append(newLexicalEntry)
            }
        }
    }
    
}

class LexicalEntry: Object {
    
    @objc dynamic var etymology = ""
    @objc dynamic var lexicalCategory = ""
    @objc dynamic var word = ""
    var entries = List<Definition>()
    
//    required init() {
//        super.init()
//        self.etymology = ""
//        self.lexicalCategory = ""
//        entries = List<Definition>()
//    }
    
    convenience required init(from lexicalEntry: DefinitionResult.Result.LexicalEntry, word: String) {
        self.init()
        if let category = lexicalEntry.lexicalCategory {
            self.lexicalCategory = category
        }
        if let entry = lexicalEntry.entries.first {
            for sense in entry.senses {
                let definition = Definition(from: sense, word: word, etymology: etymology)
                if entries.index(of: definition) == nil {
                    entries.append(definition)
                }
            }
        }
    }
    
}

class Definition: Object {
    
    @objc dynamic var id = ""
    @objc dynamic var definition = ""
    @objc dynamic var etymology = ""
    @objc dynamic var word = ""
    let domain = LinkingObjects(fromType: Domain.self, property: "definitions")
    @objc dynamic var domainName = ""
    var examples = List<String>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
//    required init() {
//        super.init()
//        self.id = ""
//        self.definition = ""
//        self.examples = List<String>()
//    }
    
    convenience required init(from sense: DefinitionResult.Result.LexicalEntry.Entry.Sense, word: String, etymology: String) {
        self.init()
        if
            let id = sense.id,
            let definitions = sense.definitions,
            let definition = definitions.first {
            self.id = id
            self.definition = definition
            self.etymology = etymology
            self.word = word
            if
                let domains = sense.domains,
                let domain = domains.first {
                self.domainName = domain
            } else {
                self.domainName = "Unknown"
            }
            if let examples = sense.examples {
                for example in examples {
                    guard let text = example.text else {
                        continue
                    }
                    self.examples.append(text)
                    
                }
            }
            DispatchQueue.main.async {
                guard self.domainName != "" else {
                    return
                }
                if let realm = self.realm {
                    if let domain = realm.object(ofType: Domain.self, forPrimaryKey: self.domainName) {
                        try! realm.write {
                            if domain.definitions.index(of: self) == nil {
                                domain.definitions.append(self)
                            }
                        }
                    } else {
                        try! realm.write {
                            let domain = Domain(withName: self.domainName)
                            domain.definitions.append(self)
                            realm.add(domain)
                        }
                    }
                }
            }
        }
    }
    
}


