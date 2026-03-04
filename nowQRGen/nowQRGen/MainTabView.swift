//
//  MainTabView.swift
//  nowQRGen
//
//  Created by nowage on 2025.06.15.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            QRGeneratorView()
                .tabItem {
                    Label("QR 생성 ⌘1", systemImage: "qrcode")
                }
                .tag(0)
            
            HistoryView()
                .tabItem {
                    Label("히스토리 ⌘2", systemImage: "clock.fill")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Label("설정 ⌘3", systemImage: "gearshape.fill")
                }
                .tag(2)
        }
        .frame(width: 800, height: 600) // 창 크기 완전 고정
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("OpenSettings"))) { _ in
            selectedTab = 2
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("SelectTab"))) { notification in
            if let tabIndex = notification.object as? Int {
                selectedTab = tabIndex
            }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(QRCodeHistory())
            .frame(width: 800, height: 600)
    }
}
