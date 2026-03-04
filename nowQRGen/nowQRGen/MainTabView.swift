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
                    Label("QR 생성", systemImage: "qrcode")
                }
                .tag(0)
            
            HistoryView()
                .tabItem {
                    Label("히스토리", systemImage: "clock.fill")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Label("설정", systemImage: "gearshape.fill")
                }
                .tag(2)
        }
        .frame(minWidth: 800, minHeight: 600)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(QRCodeHistory())
            .frame(width: 900, height: 700)
    }
}
