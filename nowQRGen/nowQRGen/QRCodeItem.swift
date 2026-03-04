//
//  QRCodeItem.swift
//  nowQRGen
//
//  Created by nowage on 2025.06.15.
//

import Foundation
import SwiftUI

struct QRCodeItem: Identifiable, Codable {
    let id = UUID()
    let text: String
    let timestamp: Date
    let filename: String?
    
    init(text: String, filename: String? = nil) {
        self.text = text
        self.timestamp = Date()
        self.filename = filename
    }
}

class QRCodeHistory: ObservableObject {
    @Published var items: [QRCodeItem] = []
    private let userDefaults = UserDefaults.standard
    private let historyKey = "QRCodeHistory"
    
    init() {
        loadHistory()
    }
    
    func addItem(_ item: QRCodeItem) {
        items.insert(item, at: 0) // 최신 항목을 맨 위에
        saveHistory()
    }
    
    func removeItem(_ item: QRCodeItem) {
        items.removeAll { $0.id == item.id }
        saveHistory()
    }
    
    func clearHistory() {
        items.removeAll()
        saveHistory()
    }
    
    private func saveHistory() {
        if let encoded = try? JSONEncoder().encode(items) {
            userDefaults.set(encoded, forKey: historyKey)
        }
    }
    
    private func loadHistory() {
        if let data = userDefaults.data(forKey: historyKey),
           let decoded = try? JSONDecoder().decode([QRCodeItem].self, from: data) {
            items = decoded
        }
    }
}
