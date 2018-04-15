//
//  DetectionModel.swift
//  MultiLanguageGlossary
//
//  Created by Artem Misesin on 4/15/18.
//  Copyright © 2018 misesin. All rights reserved.
//

import Foundation

struct LanguageDetection: Codable {
    
    struct DetectionData: Codable {
        
        struct Detection: Codable {
            var confidence: Double?
            var language: String?
        }
        
        var detections: [Detection]
    }
    
    var detectionData: DetectionData
    
}
