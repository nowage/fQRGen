# PromotionDoc (Promotion & App Store Metadata)

This document contains metadata for promotion and App Store registration of `fQRGen`.

---

## 1. App Store Metadata

### Promotion Text
> Just copy and paste from your clipboard, and your QR code is ready. Generate QR codes instantly from your Mac menu bar!

### Description
**Your QR code is ready when you copy and paste.**

fQRGen is a productivity tool that lives in your Mac menu bar, helping you generate QR codes quickly without disrupting your workflow. Simply click the menu bar icon, and you can easily convert text or URLs from your clipboard into QR codes.

**Key Features:**
*   **Instant Access**: Open the QR generation panel instantly from any app by clicking the menu bar icon. No app switching required.
*   **Clipboard Integration**: Your copied URL or text can be easily filled in. See your results immediately and save time.
*   **Versatile Formats**: Supports both PNG for web use and SVG for high-resolution printing and scaling.
*   **History Management**: Quickly review and reuse previously generated QR codes from the History panel. An essential feature for marketers and designers.
*   **Customizable Settings**: Set the app to launch at login and tailor fQRGen to your workflow.
*   **REST API Support**: Beyond the GUI, a REST API is available to generate QR codes programmatically, making it perfect for CI/CD pipelines or automation scripts.

**Recommended for:**
*   Marketers who need to share website links quickly.
*   Designers who need high-precision QR codes for print materials.
*   Productivity enthusiasts who want to manage frequently used links as QR codes.

### Keywords
QR, Code, Generator, Mac, Productivity, MenuBar, SVG, PNG, API, Clipboard

### Support URL
[https://finfra.kr/w1/?category_name=fqrgen](https://finfra.kr/w1/?category_name=fqrgen)

### Marketing URL
[https://finfra.kr/product/fQRGen/en/index.html](https://finfra.kr/product/fQRGen/en/index.html)

---

## 2. Promotion & Usage Guide

### Get Started in 3 Steps
1.  **Install**: Download the app and move it to your Applications folder.
2.  **Launch**: Once the menu bar icon appears, click the icon to open the panel.
3.  **Generate**: Enter text or copy to clipboard, choose your format (PNG/SVG), and download.

### Automate with the REST API (For Developers)
To generate QR codes programmatically, use the following endpoint:

- **Endpoint**: `POST /api/generate`
- **Body**: `{"data": "https://example.com", "format": "png"}` (format: 'png' or 'svg')

```bash
# Example: Generate QR code as PNG
curl -X POST https://[ServiceURL]/api/generate \
     -H "Content-Type: application/json" \
     -d '{"data":"https://finfra.kr", "format":"png"}' \
     --output qrcode.png
```

---
*Last Updated: 2026-03-06*
