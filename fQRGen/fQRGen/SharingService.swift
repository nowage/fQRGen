//
//  SharingService.swift
//  fQRGen
//
//  Created by nowage on 2025.06.15.
//

import AppKit
import SwiftUI

struct SharingService {
    /// macOS 공유 서비스를 통해 아이템 공유
    /// - Parameters:
    ///   - items: 공유할 아이템들
    ///   - sourceView: 공유 버튼의 뷰 (위치 참조용)
    static func share(_ items: [Any], from sourceView: NSView) {
        let sharingServicePicker = NSSharingServicePicker(items: items)
        sharingServicePicker.show(relativeTo: sourceView.bounds, of: sourceView, preferredEdge: .maxY)
    }
    
    /// 간단한 공유 함수 (뷰 없이)
    /// - Parameter items: 공유할 아이템들
    static func shareItems(_ items: [Any]) {
        guard let window = NSApplication.shared.keyWindow else { return }
        
        let sharingServicePicker = NSSharingServicePicker(items: items)
        if let contentView = window.contentView {
            let centerRect = NSRect(
                x: contentView.bounds.midX - 50,
                y: contentView.bounds.midY - 25,
                width: 100,
                height: 50
            )
            sharingServicePicker.show(relativeTo: centerRect, of: contentView, preferredEdge: .maxY)
        }
    }
}
