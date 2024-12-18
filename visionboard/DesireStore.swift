//
//  DesireStore.swift
//  visionboard
//
//  Created by Anthony Francis on 18/12/2024.
//

import Foundation

class DesireStore: ObservableObject {
    @Published var desires: [Desire] = []
    @Published var totalManifestCount: Int = 0
    
    private let saveKey = "SavedDesires"
    private let manifestCountKey = "TotalManifestCount"
    
    init() {
        loadDesires()
        totalManifestCount = UserDefaults.standard.integer(forKey: manifestCountKey)
    }
    
    func addDesire(_ desire: Desire) {
        desires.append(desire)
        saveDesires()
    }
    
    func removeDesire(at index: Int) {
        desires.remove(at: index)
        saveDesires()
    }
    
    func updateDesire(_ desire: Desire) {
        if let index = desires.firstIndex(where: { $0.id == desire.id }) {
            desires[index] = desire
            saveDesires()
        }
    }
    
    func updateTotalManifestCount(_ count: Int) {
        totalManifestCount = count
        UserDefaults.standard.set(count, forKey: manifestCountKey)
    }
    
    private func saveDesires() {
        if let encoded = try? JSONEncoder().encode(desires) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadDesires() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode([Desire].self, from: data) {
                desires = decoded
            }
        }
    }
}
