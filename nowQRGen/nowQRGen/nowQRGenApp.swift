//
//  nowQRGenApp.swift
//  nowQRGen
//
//  Created by nowage on 2025.06.15.
//

import SwiftUI

@main
struct nowQRGenApp: App {
    @StateObject private var menuBarManager = MenuBarManager()
    @StateObject private var history = QRCodeHistory()
    @AppStorage("appLanguage") private var appLanguage: String = "ko" // Default to Korean
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(history)
                .environment(\.locale, Locale(identifier: appLanguage))
                .frame(minWidth: 600, minHeight: 500)
                .onAppear {
                    menuBarManager.setupMenuBar()
                }
                .onDisappear {
                    // 앱이 완전히 종료될 때만 메뉴바 아이템 제거
                }
        }
        
        Settings {
            SettingsView()
                .environmentObject(history)
                .environment(\.locale, Locale(identifier: appLanguage))
                .frame(minWidth: 500, minHeight: 400)
        }
    }
}