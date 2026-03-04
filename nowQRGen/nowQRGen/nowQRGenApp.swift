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
            MainTabView() // ContentView 대신 MainTabView 사용
                .environmentObject(history)
                .environment(\.locale, Locale(identifier: appLanguage))
                .onAppear {
                    menuBarManager.setupMenuBar()
                }
                .onDisappear {
                    // 앱이 완전히 종료될 때만 메뉴바 아이템 제거
                }
        }
        // macOS 12.0 호환을 위해 windowResizability 제거 (MainTabView의 고정된 frame으로 처리됨)
        .windowStyle(.hiddenTitleBar)
        .commands {
            CommandGroup(replacing: .appSettings) {
                Button("환경설정...") {
                    NotificationCenter.default.post(name: Notification.Name("OpenSettings"), object: nil)
                }
                .keyboardShortcut(",", modifiers: .command)
            }
        }
    }
}