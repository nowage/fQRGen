#!/usr/bin/env python3
"""
nowQRGen UI 문자열을 다국어로 번역하는 스크립트
ko(한국어) 기준으로 en 번역 (향후 추가 예정: ja, de, es, fr, zh-Hans, zh-Hant)
"""
import os
import re

RESOURCES_DIR = 'nowQRGen/nowQRGen'

TRANSLATIONS = {
    # === 탭 이름 ===
    "QR 생성": {
        "ko": "QR 생성", "en": "QR Code", "ja": "QRコード",
        "de": "QR-Code", "es": "Código QR", "fr": "Code QR",
        "zh-Hans": "二维码", "zh-Hant": "QR碼"
    },
    "히스토리": {
        "ko": "히스토리", "en": "History", "ja": "履歴",
        "de": "Verlauf", "es": "Historial", "fr": "Historique",
        "zh-Hans": "历史", "zh-Hant": "歷史"
    },
    "설정": {
        "ko": "설정", "en": "Settings", "ja": "設定",
        "de": "Einstellungen", "es": "Ajustes", "fr": "Réglages",
        "zh-Hans": "设置", "zh-Hant": "設定"
    },

    # === 타이틀 ===
    "QR 코드 생성기": {
        "ko": "QR 코드 생성기", "en": "QR Code Generator", "ja": "QRコードジェネレーター",
        "de": "QR-Code-Generator", "es": "Generador de Códigos QR", "fr": "Générateur de code QR",
        "zh-Hans": "二维码生成器", "zh-Hant": "QR碼生成器"
    },
    "QR 코드 히스토리": {
        "ko": "QR 코드 히스토리", "en": "QR Code History", "ja": "QRコード履歴",
        "de": "QR-Code-Verlauf", "es": "Historial de Códigos QR", "fr": "Historique des codes QR",
        "zh-Hans": "二维码历史", "zh-Hant": "QR碼歷史"
    },
    "QR 코드 상세보기": {
        "ko": "QR 코드 상세보기", "en": "QR Code Details", "ja": "QRコード詳細",
        "de": "QR-Code Details", "es": "Detalles del Código QR", "fr": "Détails du code QR",
        "zh-Hans": "二维码详情", "zh-Hant": "QR碼詳情"
    },

    # === 입력 레이블 ===
    "URL 또는 텍스트 입력:": {
        "ko": "URL 또는 텍스트 입력:", "en": "Enter URL or Text:", "ja": "URLまたはテキストを入力:",
        "de": "URL oder Text eingeben:", "es": "Ingresa URL o Texto:", "fr": "Entrer URL ou Texte:",
        "zh-Hans": "输入URL或文本:", "zh-Hant": "輸入URL或文字:"
    },
    "빠른 입력:": {
        "ko": "빠른 입력:", "en": "Quick Input:", "ja": "クイック入力:",
        "de": "Schnelleingabe:", "es": "Entrada rápida:", "fr": "Saisie rapide:",
        "zh-Hans": "快速输入:", "zh-Hant": "快速輸入:"
    },

    # === 빠른 입력 버튼 ===
    "웹사이트": {
        "ko": "웹사이트", "en": "Website", "ja": "ウェブサイト",
        "de": "Website", "es": "Sitio web", "fr": "Site web",
        "zh-Hans": "网站", "zh-Hant": "網站"
    },
    "이메일": {
        "ko": "이메일", "en": "Email", "ja": "メール",
        "de": "E-Mail", "es": "Correo", "fr": "E-mail",
        "zh-Hans": "电子邮件", "zh-Hant": "電子郵件"
    },
    "전화번호": {
        "ko": "전화번호", "en": "Phone", "ja": "電話番号",
        "de": "Telefon", "es": "Teléfono", "fr": "Téléphone",
        "zh-Hans": "电话", "zh-Hant": "電話"
    },
    "WiFi": {
        "ko": "WiFi", "en": "WiFi", "ja": "WiFi",
        "de": "WiFi", "es": "WiFi", "fr": "WiFi",
        "zh-Hans": "WiFi", "zh-Hant": "WiFi"
    },
    "문자메시지": {
        "ko": "문자메시지", "en": "SMS", "ja": "SMS",
        "de": "SMS", "es": "SMS", "fr": "SMS",
        "zh-Hans": "短信", "zh-Hant": "簡訊"
    },
    "연락처": {
        "ko": "연락처", "en": "Contact", "ja": "連絡先",
        "de": "Kontakt", "es": "Contacto", "fr": "Contact",
        "zh-Hans": "联系人", "zh-Hant": "聯絡人"
    },

    # === 액션 버튼 ===
    "저장": {
        "ko": "저장", "en": "Save", "ja": "保存",
        "de": "Speichern", "es": "Guardar", "fr": "Enregistrer",
        "zh-Hans": "保存", "zh-Hant": "儲存"
    },
    "공유": {
        "ko": "공유", "en": "Share", "ja": "共有",
        "de": "Teilen", "es": "Compartir", "fr": "Partager",
        "zh-Hans": "分享", "zh-Hant": "分享"
    },
    "복사": {
        "ko": "복사", "en": "Copy", "ja": "コピー",
        "de": "Kopieren", "es": "Copiar", "fr": "Copier",
        "zh-Hans": "复制", "zh-Hant": "複製"
    },
    "다운로드": {
        "ko": "다운로드", "en": "Download", "ja": "ダウンロード",
        "de": "Herunterladen", "es": "Descargar", "fr": "Télécharger",
        "zh-Hans": "下载", "zh-Hant": "下載"
    },
    "삭제": {
        "ko": "삭제", "en": "Delete", "ja": "削除",
        "de": "Löschen", "es": "Eliminar", "fr": "Supprimer",
        "zh-Hans": "删除", "zh-Hant": "刪除"
    },
    "닫기": {
        "ko": "닫기", "en": "Close", "ja": "閉じる",
        "de": "Schließen", "es": "Cerrar", "fr": "Fermer",
        "zh-Hans": "关闭", "zh-Hant": "關閉"
    },
    "전체 삭제": {
        "ko": "전체 삭제", "en": "Clear All", "ja": "全て削除",
        "de": "Alle löschen", "es": "Borrar todo", "fr": "Tout effacer",
        "zh-Hans": "全部删除", "zh-Hant": "全部刪除"
    },
    "상세보기": {
        "ko": "상세보기", "en": "Details", "ja": "詳細",
        "de": "Details", "es": "Detalles", "fr": "Détails",
        "zh-Hans": "详情", "zh-Hant": "詳情"
    },
    "QR 코드 생성": {
        "ko": "QR 코드 생성", "en": "Generate QR Code", "ja": "QRコード生成",
        "de": "QR-Code erstellen", "es": "Generar código QR", "fr": "Générer un code QR",
        "zh-Hans": "生成二维码", "zh-Hant": "產生QR碼"
    },
    "고급 설정": {
        "ko": "고급 설정", "en": "Advanced Settings", "ja": "詳細設定",
        "de": "Erweiterte Einstellungen", "es": "Ajustes avanzados", "fr": "Paramètres avancés",
        "zh-Hans": "高级设置", "zh-Hant": "進階設定"
    },

    # === 정보 레이블 ===
    "크기:": {
        "ko": "크기:", "en": "Size:", "ja": "サイズ:",
        "de": "Größe:", "es": "Tamaño:", "fr": "Taille:",
        "zh-Hans": "尺寸:", "zh-Hant": "大小:"
    },
    "오류 정정:": {
        "ko": "오류 정정:", "en": "Error Correction:", "ja": "誤り訂正:",
        "de": "Fehlerkorrektur:", "es": "Corrección de errores:", "fr": "Correction d'erreur:",
        "zh-Hans": "纠错级别:", "zh-Hant": "錯誤修正:"
    },
    "생성 시간:": {
        "ko": "생성 시간:", "en": "Created:", "ja": "作成日時:",
        "de": "Erstellt:", "es": "Creado:", "fr": "Créé:",
        "zh-Hans": "创建时间:", "zh-Hant": "建立時間:"
    },
    "내용:": {
        "ko": "내용:", "en": "Content:", "ja": "内容:",
        "de": "Inhalt:", "es": "Contenido:", "fr": "Contenu:",
        "zh-Hans": "内容:", "zh-Hant": "內容:"
    },
    "생성된 QR 코드:": {
        "ko": "생성된 QR 코드:", "en": "Generated QR Code:", "ja": "生成されたQRコード:",
        "de": "Generierter QR-Code:", "es": "Código QR generado:", "fr": "Code QR généré:",
        "zh-Hans": "生成的二维码:", "zh-Hant": "生成的QR碼:"
    },

    # === 알림/메시지 ===
    "QR 생성 완료": {
        "ko": "QR 생성 완료", "en": "QR Code Generated", "ja": "QRコード生成完了",
        "de": "QR-Code erstellt", "es": "Código QR generado", "fr": "Code QR généré",
        "zh-Hans": "二维码已生成", "zh-Hant": "QR碼已生成"
    },
    "QR 생성 실패": {
        "ko": "QR 생성 실패", "en": "QR Generation Failed", "ja": "QRコード生成失敗",
        "de": "QR-Code-Erstellung fehlgeschlagen", "es": "Error al generar QR", "fr": "Échec de génération",
        "zh-Hans": "二维码生成失败", "zh-Hant": "QR碼生成失敗"
    },
    "저장 실패": {
        "ko": "저장 실패", "en": "Save Failed", "ja": "保存失敗",
        "de": "Speichern fehlgeschlagen", "es": "Error al guardar", "fr": "Échec de l'enregistrement",
        "zh-Hans": "保存失败", "zh-Hant": "儲存失敗"
    },
    "알림": {
        "ko": "알림", "en": "Notice", "ja": "お知らせ",
        "de": "Hinweis", "es": "Aviso", "fr": "Avis",
        "zh-Hans": "通知", "zh-Hant": "通知"
    },
    "QR 코드 저장에 실패했습니다.": {
        "ko": "QR 코드 저장에 실패했습니다.", "en": "Failed to save QR code.", "ja": "QRコードの保存に失敗しました。",
        "de": "QR-Code konnte nicht gespeichert werden.", "es": "No se pudo guardar el código QR.",
        "fr": "Impossible d'enregistrer le code QR.",
        "zh-Hans": "QR码保存失败。", "zh-Hant": "QR碼儲存失敗。"
    },
    "QR 코드를 생성할 수 없습니다.": {
        "ko": "QR 코드를 생성할 수 없습니다.", "en": "Cannot generate QR code.", "ja": "QRコードを生成できません。",
        "de": "QR-Code kann nicht generiert werden.", "es": "No se puede generar el código QR.",
        "fr": "Impossible de générer le code QR.",
        "zh-Hans": "无法生成QR码。", "zh-Hant": "無法生成QR碼。"
    },

    # === 빈 상태 ===
    "생성된 QR 코드가 없습니다": {
        "ko": "생성된 QR 코드가 없습니다", "en": "No QR codes yet", "ja": "QRコードがありません",
        "de": "Keine QR-Codes vorhanden", "es": "Aún no hay códigos QR", "fr": "Aucun code QR pour l'instant",
        "zh-Hans": "还没有二维码", "zh-Hant": "尚無QR碼"
    },
    "QR 생성 탭에서 QR 코드를 생성해보세요": {
        "ko": "QR 생성 탭에서 QR 코드를 생성해보세요", "en": "Go to QR Code tab to create one",
        "ja": "QRコードタブで作成してください", "de": "Gehen Sie zum QR-Code-Tab",
        "es": "Ve a la pestaña QR para crear uno", "fr": "Allez dans l'onglet QR pour en créer un",
        "zh-Hans": "前往QR码标签页创建", "zh-Hant": "前往QR碼標籤頁建立"
    },
    "검색 결과가 없습니다": {
        "ko": "검색 결과가 없습니다", "en": "No results found", "ja": "検索結果がありません",
        "de": "Keine Ergebnisse", "es": "Sin resultados", "fr": "Aucun résultat",
        "zh-Hans": "没有搜索结果", "zh-Hant": "沒有搜尋結果"
    },
    "다른 검색어를 시도해보세요": {
        "ko": "다른 검색어를 시도해보세요", "en": "Try a different search term",
        "ja": "別の検索ワードをお試しください", "de": "Versuchen Sie einen anderen Suchbegriff",
        "es": "Intenta con otro término", "fr": "Essayez un autre terme de recherche",
        "zh-Hans": "尝试其他搜索词", "zh-Hant": "試試其他搜尋詞"
    },

    # === 메뉴바 ===
    "빠른 QR 생성": {
        "ko": "빠른 QR 생성", "en": "Quick QR Generate", "ja": "クイックQR生成",
        "de": "Schnell-QR erstellen", "es": "Generar QR rápido", "fr": "Générer QR rapide",
        "zh-Hans": "快速生成QR码", "zh-Hant": "快速生成QR碼"
    },
    "앱 열기": {
        "ko": "앱 열기", "en": "Open App", "ja": "アプリを開く",
        "de": "App öffnen", "es": "Abrir app", "fr": "Ouvrir l'app",
        "zh-Hans": "打开应用", "zh-Hant": "開啟應用程式"
    },
    "종료": {
        "ko": "종료", "en": "Quit", "ja": "終了",
        "de": "Beenden", "es": "Salir", "fr": "Quitter",
        "zh-Hans": "退出", "zh-Hant": "結束"
    },
    "클립보드가 비어있습니다": {
        "ko": "클립보드가 비어있습니다", "en": "Clipboard is empty", "ja": "クリップボードが空です",
        "de": "Zwischenablage ist leer", "es": "El portapapeles está vacío", "fr": "Le presse-papiers est vide",
        "zh-Hans": "剪贴板为空", "zh-Hant": "剪貼簿是空的"
    },

    # === 기타 ===
    "GitHub 저장소": {
        "ko": "GitHub 저장소", "en": "GitHub Repository", "ja": "GitHubリポジトリ",
        "de": "GitHub-Repository", "es": "Repositorio GitHub", "fr": "Référentiel GitHub",
        "zh-Hans": "GitHub仓库", "zh-Hant": "GitHub儲存庫"
    },
    "개": {
        "ko": "개", "en": "items", "ja": "個",
        "de": "Elemente", "es": "elementos", "fr": "éléments",
        "zh-Hans": "个", "zh-Hant": "個"
    },
    "버전": {
        "ko": "버전", "en": "Version", "ja": "バージョン",
        "de": "Version", "es": "Versión", "fr": "Version",
        "zh-Hans": "版本", "zh-Hant": "版本"
    },
    "개발자": {
        "ko": "개발자", "en": "Developer", "ja": "開発者",
        "de": "Entwickler", "es": "Desarrollador", "fr": "Développeur",
        "zh-Hans": "开发者", "zh-Hant": "開發者"
    },
    "출시일": {
        "ko": "출시일", "en": "Release Date", "ja": "リリース日",
        "de": "Veröffentlichungsdatum", "es": "Fecha de lanzamiento", "fr": "Date de sortie",
        "zh-Hans": "发布日期", "zh-Hant": "發布日期"
    },
}

def parse_strings_file(filepath):
    entries = {}
    if not os.path.exists(filepath):
        return entries
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    pattern = re.compile(r'"((?:[^"\\]|\\.)*)"\s*=\s*"((?:[^"\\]|\\.)*)"\s*;')
    for m in pattern.finditer(content):
        entries[m.group(1)] = m.group(2)
    return entries


def write_strings_file(filepath, entries, lang):
    os.makedirs(os.path.dirname(filepath), exist_ok=True)
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(f'/* Localizable.strings ({lang}) */\n')
        f.write('/* Auto-generated by translate-all-strings.py */\n\n')
        for key in sorted(entries.keys()):
            ek = key.replace('\\', '\\\\').replace('"', '\\"')
            ev = entries[key].replace('\\', '\\\\').replace('"', '\\"')
            f.write(f'"{ek}" = "{ev}";\n')


def translate_file(lang, filename):
    filepath = os.path.join(RESOURCES_DIR, f'{lang}.lproj', filename)
    entries = parse_strings_file(filepath)

    updated = 0
    added = 0

    for key in list(entries.keys()):
        if key in TRANSLATIONS and lang in TRANSLATIONS[key]:
            new_value = TRANSLATIONS[key][lang]
            if entries[key] != new_value:
                entries[key] = new_value
                updated += 1

    if filename == 'Localizable.strings':
        for key in TRANSLATIONS.keys():
            if key not in entries and lang in TRANSLATIONS[key]:
                entries[key] = TRANSLATIONS[key][lang]
                added += 1

    write_strings_file(filepath, entries, lang)
    return updated, added


def main():
    languages = ['en', 'ko', 'ja', 'de', 'es', 'fr', 'zh-Hans', 'zh-Hant']

    print('=== Starting Translation ===\n')

    total_updated = 0
    total_added = 0
    for lang in languages:
        print(f'{lang}:')
        updated, added = translate_file(lang, 'Localizable.strings')
        print(f'  Localizable.strings: {updated} updated, {added} added')
        total_updated += updated
        total_added += added
        print()

    print(f'=== Total: {total_updated} updated, {total_added} added ===')


if __name__ == '__main__':
    main()
