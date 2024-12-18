//
//  Desire.swift
//  visionboard
//
//  Created by Anthony Francis on 18/12/2024.
//

import Foundation

struct Desire: Identifiable, Codable {
    let id: UUID
    let text: String
    let category: String
    var manifestCount: Int
    var imageData: Data?
    
    init(text: String, category: String, manifestCount: Int = 0, imageData: Data? = nil) {
        self.id = UUID()
        self.text = text
        self.category = category
        self.manifestCount = manifestCount
        self.imageData = imageData
    }
}
