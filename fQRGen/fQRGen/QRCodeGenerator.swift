//
//  QRCodeGenerator.swift
//  fQRGen
//
//  Created by nowage on 2025.06.15.
//

import CoreImage
import AppKit
import SwiftUI

#if canImport(UniformTypeIdentifiers)
import UniformTypeIdentifiers
#endif

class QRCodeGenerator: ObservableObject {
    private let context = CIContext()
    
    /// QR 코드 생성
    /// - Parameters:
    ///   - text: QR 코드에 인코딩할 텍스트
    ///   - scale: 이미지 크기 배율 (기본: 10)
    ///   - correctionLevel: 오류 정정 레벨 (기본: H)
    /// - Returns: NSImage 또는 nil
    func generateQRCode(from text: String, scale: CGFloat = 10, correctionLevel: String = "H") -> NSImage? {
        guard let data = text.data(using: .utf8) else { return nil }
        
        // CIFilter 생성
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue(correctionLevel, forKey: "inputCorrectionLevel")
        
        guard let outputImage = filter.outputImage else { return nil }
        
        // 스케일 적용
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        let scaledImage = outputImage.transformed(by: transform)
        
        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else { return nil }
        
        return NSImage(cgImage: cgImage, size: NSSize(width: scaledImage.extent.width, height: scaledImage.extent.height))
    }
    
    /// QR 코드를 파일로 저장 (macOS 스타일)
    /// - Parameters:
    ///   - image: 저장할 NSImage
    ///   - suggestedFilename: 제안 파일명
    /// - Returns: 저장 성공 여부
    @discardableResult
    func saveQRCodeToFile(_ image: NSImage, suggestedFilename: String = "QRCode.png") -> Bool {
        let savePanel = NSSavePanel()
        savePanel.title = "QR 코드 저장".localized
        savePanel.message = "QR 코드를 저장할 위치를 선택하세요".localized
        savePanel.nameFieldStringValue = suggestedFilename
        
        // macOS 버전별 호환성 처리
        #if canImport(UniformTypeIdentifiers)
        if #available(macOS 11.0, *) {
            savePanel.allowedContentTypes = [UTType.png]
        } else {
            savePanel.allowedFileTypes = ["png"]
        }
        #else
        savePanel.allowedFileTypes = ["png"]
        #endif
        
        savePanel.canCreateDirectories = true
        
        guard savePanel.runModal() == .OK,
              let url = savePanel.url else {
            return false
        }
        
        return saveImageToURL(image, url: url)
    }
    
    /// 이미지를 지정된 URL에 저장
    /// - Parameters:
    ///   - image: 저장할 NSImage
    ///   - url: 저장할 URL
    /// - Returns: 저장 성공 여부
    func saveImageToURL(_ image: NSImage, url: URL) -> Bool {
        guard let tiffData = image.tiffRepresentation,
              let bitmapRep = NSBitmapImageRep(data: tiffData) else {
            return false
        }
        
        // PNG 전용으로 단순화
        guard let imageData = bitmapRep.representation(using: .png, properties: [:]) else {
            return false
        }
        
        do {
            try imageData.write(to: url)
            return true
        } catch {
            print("파일 저장 실패: \(error)")
            return false
        }
    }
    
    /// 빠른 저장 (Downloads 폴더)
    /// - Parameters:
    ///   - image: 저장할 NSImage
    ///   - filename: 파일명 (확장자 포함)
    /// - Returns: 저장된 파일 URL
    func quickSaveToDownloads(_ image: NSImage, filename: String = "qr-\(Date().timeIntervalSince1970).png") -> URL? {
        guard let downloadsURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let fileURL = downloadsURL.appendingPathComponent(filename)
        
        return saveImageToURL(image, url: fileURL) ? fileURL : nil
    }
}