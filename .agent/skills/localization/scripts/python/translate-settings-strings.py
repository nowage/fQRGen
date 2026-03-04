#!/usr/bin/env python3
"""
Usage:
  python3 translate-settings-strings.py

Arguments:
  없음 - 프로젝트 루트에서 실행하면 됩니다.
         nowQRGen/nowQRGen/SettingsView.swift 의 설정 UI 문자열을
         nowQRGen/nowQRGen/{lang}.lproj/Localizable.strings 파일에 번역하여 추가합니다.
"""

import os
import re

RESOURCES_DIR = 'nowQRGen/nowQRGen'

# nowQRGen 설정(SettingsView) UI 번역 사전
SETTINGS_TRANSLATIONS = {
    # 설정 탭 제목
    "설정": {
        "ko": "설정",
        "en": "Settings",
        "ja": "設定",
        "de": "Einstellungen",
        "es": "Ajustes",
        "fr": "Paramètres",
        "zh-Hans": "设置",
        "zh-Hant": "設定",
    },

    # 기본 설정 섹션
    "기본 설정": {
        "ko": "기본 설정",
        "en": "Default Settings",
        "ja": "デフォルト設定",
        "de": "Standardeinstellungen",
        "es": "Configuración predeterminada",
        "fr": "Paramètres par défaut",
        "zh-Hans": "默认设置",
        "zh-Hant": "預設設定",
    },
    "기본 QR 코드 크기": {
        "ko": "기본 QR 코드 크기",
        "en": "Default QR Code Size",
        "ja": "デフォルトQRコードサイズ",
        "de": "Standard-QR-Code-Größe",
        "es": "Tamaño predeterminado del código QR",
        "fr": "Taille par défaut du code QR",
        "zh-Hans": "默认二维码大小",
        "zh-Hant": "預設二維碼大小",
    },
    "기본 오류 정정 레벨": {
        "ko": "기본 오류 정정 레벨",
        "en": "Default Error Correction Level",
        "ja": "デフォルトエラー訂正レベル",
        "de": "Standard-Fehlerkorrekturlevel",
        "es": "Nivel de corrección de errores predeterminado",
        "fr": "Niveau de correction d'erreur par défaut",
        "zh-Hans": "默认纠错级别",
        "zh-Hant": "預設錯誤更正等級",
    },
    "오류 정정 레벨": {
        "ko": "오류 정정 레벨",
        "en": "Error Correction Level",
        "ja": "エラー訂正レベル",
        "de": "Fehlerkorrekturlevel",
        "es": "Nivel de corrección de errores",
        "fr": "Niveau de correction d'erreur",
        "zh-Hans": "纠错级别",
        "zh-Hant": "錯誤更正等級",
    },

    # 언어 설정 섹션
    "언어 설정": {
        "ko": "언어 설정",
        "en": "Language Settings",
        "ja": "言語設定",
        "de": "Spracheinstellungen",
        "es": "Configuración de idioma",
        "fr": "Paramètres de langue",
        "zh-Hans": "语言设置",
        "zh-Hant": "語言設定",
    },
    "언어 선택": {
        "ko": "언어 선택",
        "en": "Select Language",
        "ja": "言語を選択",
        "de": "Sprache auswählen",
        "es": "Seleccionar idioma",
        "fr": "Choisir la langue",
        "zh-Hans": "选择语言",
        "zh-Hant": "選擇語言",
    },
    "한국어": { "ko": "한국어", "en": "한국어", "ja": "한국어", "de": "한국어", "es": "한국어", "fr": "한국어", "zh-Hans": "한국어", "zh-Hant": "한국어" },
    "English": { "ko": "English", "en": "English", "ja": "English", "de": "English", "es": "English", "fr": "English", "zh-Hans": "English", "zh-Hant": "English" },
    "日本語": { "ko": "日本語", "en": "日本語", "ja": "日本語", "de": "日本語", "es": "日本語", "fr": "日本語", "zh-Hans": "日本語", "zh-Hant": "日本語" },
    "Deutsch": { "ko": "Deutsch", "en": "Deutsch", "ja": "Deutsch", "de": "Deutsch", "es": "Deutsch", "fr": "Deutsch", "zh-Hans": "Deutsch", "zh-Hant": "Deutsch" },
    "Español": { "ko": "Español", "en": "Español", "ja": "Español", "de": "Español", "es": "Español", "fr": "Español", "zh-Hans": "Español", "zh-Hant": "Español" },
    "Français": { "ko": "Français", "en": "Français", "ja": "Français", "de": "Français", "es": "Français", "fr": "Français", "zh-Hans": "Français", "zh-Hant": "Français" },
    "简体中文": { "ko": "简体中文", "en": "简体中文", "ja": "简体中文", "de": "简体中文", "es": "简体中文", "fr": "简体中文", "zh-Hans": "简体中文", "zh-Hant": "简体中文" },
    "繁體中文": { "ko": "繁體中文", "en": "繁體中文", "ja": "繁體中文", "de": "繁體中文", "es": "繁體中文", "fr": "繁體中文", "zh-Hans": "繁體中文", "zh-Hant": "繁體中文" },

    # 오류 정정 레벨 값
    "낮음 (~7%)": {
        "ko": "낮음 (~7%)",
        "en": "Low (~7%)",
        "ja": "低い (~7%)",
        "de": "Niedrig (~7%)",
        "es": "Bajo (~7%)",
        "fr": "Faible (~7%)",
        "zh-Hans": "低 (~7%)",
        "zh-Hant": "低 (~7%)",
    },
    "중간 (~15%)": {
        "ko": "중간 (~15%)",
        "en": "Medium (~15%)",
        "ja": "中程度 (~15%)",
        "de": "Mittel (~15%)",
        "es": "Medio (~15%)",
        "fr": "Moyen (~15%)",
        "zh-Hans": "中 (~15%)",
        "zh-Hant": "中 (~15%)",
    },
    "높음 (~25%)": {
        "ko": "높음 (~25%)",
        "en": "High (~25%)",
        "ja": "高い (~25%)",
        "de": "Hoch (~25%)",
        "es": "Alto (~25%)",
        "fr": "Élevé (~25%)",
        "zh-Hans": "高 (~25%)",
        "zh-Hant": "高 (~25%)",
    },
    "최고 (~30%)": {
        "ko": "최고 (~30%)",
        "en": "Highest (~30%)",
        "ja": "最高 (~30%)",
        "de": "Höchste (~30%)",
        "es": "Máximo (~30%)",
        "fr": "Maximum (~30%)",
        "zh-Hans": "最高 (~30%)",
        "zh-Hant": "最高 (~30%)",
    },

    # 히스토리 관리 섹션
    "히스토리 관리": {
        "ko": "히스토리 관리",
        "en": "History Management",
        "ja": "履歴管理",
        "de": "Verlaufsverwaltung",
        "es": "Gestión del historial",
        "fr": "Gestion de l'historique",
        "zh-Hans": "历史记录管理",
        "zh-Hant": "歷史記錄管理",
    },
    "저장된 QR 코드": {
        "ko": "저장된 QR 코드",
        "en": "Saved QR Codes",
        "ja": "保存されたQRコード",
        "de": "Gespeicherte QR-Codes",
        "es": "Códigos QR guardados",
        "fr": "Codes QR enregistrés",
        "zh-Hans": "已保存的二维码",
        "zh-Hant": "已儲存的二維碼",
    },
    "전체 삭제": {
        "ko": "전체 삭제",
        "en": "Clear All",
        "ja": "すべて削除",
        "de": "Alles löschen",
        "es": "Borrar todo",
        "fr": "Tout effacer",
        "zh-Hans": "全部删除",
        "zh-Hant": "全部刪除",
    },

    # 확인 다이얼로그
    "히스토리 전체 삭제": {
        "ko": "히스토리 전체 삭제",
        "en": "Clear All History",
        "ja": "履歴をすべて削除",
        "de": "Gesamten Verlauf löschen",
        "es": "Borrar todo el historial",
        "fr": "Effacer tout l'historique",
        "zh-Hans": "清除所有历史记录",
        "zh-Hant": "清除所有歷史記錄",
    },
    "모든 QR 코드 히스토리가 삭제됩니다. 이 작업은 되돌릴 수 없습니다.": {
        "ko": "모든 QR 코드 히스토리가 삭제됩니다. 이 작업은 되돌릴 수 없습니다.",
        "en": "All QR code history will be deleted. This action cannot be undone.",
        "ja": "すべてのQRコード履歴が削除されます。この操作は取り消せません。",
        "de": "Der gesamte QR-Code-Verlauf wird gelöscht. Diese Aktion kann nicht rückgängig gemacht werden.",
        "es": "Se eliminará todo el historial de códigos QR. Esta acción no se puede deshacer.",
        "fr": "Tout l'historique des codes QR sera supprimé. Cette action ne peut pas être annulée.",
        "zh-Hans": "所有二维码历史记录将被删除。此操作无法撤销。",
        "zh-Hant": "所有二維碼歷史記錄將被刪除。此操作無法復原。",
    },
    "삭제": {
        "ko": "삭제",
        "en": "Delete",
        "ja": "削除",
        "de": "Löschen",
        "es": "Eliminar",
        "fr": "Supprimer",
        "zh-Hans": "删除",
        "zh-Hant": "刪除",
    },
    "취소": {
        "ko": "취소",
        "en": "Cancel",
        "ja": "キャンセル",
        "de": "Abbrechen",
        "es": "Cancelar",
        "fr": "Annuler",
        "zh-Hans": "取消",
        "zh-Hant": "取消",
    },

    # 앱 정보 섹션
    "앱 정보": {
        "ko": "앱 정보",
        "en": "App Info",
        "ja": "アプリ情報",
        "de": "App-Informationen",
        "es": "Información de la app",
        "fr": "Informations sur l'application",
        "zh-Hans": "应用信息",
        "zh-Hant": "應用程式資訊",
    },
    "버전": {
        "ko": "버전",
        "en": "Version",
        "ja": "バージョン",
        "de": "Version",
        "es": "Versión",
        "fr": "Version",
        "zh-Hans": "版本",
        "zh-Hant": "版本",
    },
    "개발자": {
        "ko": "개발자",
        "en": "Developer",
        "ja": "開発者",
        "de": "Entwickler",
        "es": "Desarrollador",
        "fr": "Développeur",
        "zh-Hans": "开发者",
        "zh-Hant": "開發者",
    },
    "출시일": {
        "ko": "출시일",
        "en": "Release Date",
        "ja": "リリース日",
        "de": "Erscheinungsdatum",
        "es": "Fecha de lanzamiento",
        "fr": "Date de sortie",
        "zh-Hans": "发布日期",
        "zh-Hant": "發布日期",
    },
    "GitHub 저장소": {
        "ko": "GitHub 저장소",
        "en": "GitHub Repository",
        "ja": "GitHubリポジトリ",
        "de": "GitHub-Repository",
        "es": "Repositorio GitHub",
        "fr": "Dépôt GitHub",
        "zh-Hans": "GitHub 仓库",
        "zh-Hant": "GitHub 存儲庫",
    },

    # 지원 기능 섹션
    "지원 기능": {
        "ko": "지원 기능",
        "en": "Supported Features",
        "ja": "サポートされる機能",
        "de": "Unterstützte Funktionen",
        "es": "Funciones compatibles",
        "fr": "Fonctionnalités prises en charge",
        "zh-Hans": "支持的功能",
        "zh-Hant": "支援的功能",
    },
    "PNG 이미지 내보내기": {
        "ko": "PNG 이미지 내보내기",
        "en": "PNG Image Export",
        "ja": "PNG画像エクスポート",
        "de": "PNG-Bild exportieren",
        "es": "Exportar imagen PNG",
        "fr": "Exporter l'image PNG",
        "zh-Hans": "导出PNG图像",
        "zh-Hant": "匯出PNG圖像",
    },
    "크기 조절 (5x ~ 20x)": {
        "ko": "크기 조절 (5x ~ 20x)",
        "en": "Size Adjustment (5x ~ 20x)",
        "ja": "サイズ調整 (5x ~ 20x)",
        "de": "Größenanpassung (5x ~ 20x)",
        "es": "Ajuste de tamaño (5x ~ 20x)",
        "fr": "Réglage de la taille (5x ~ 20x)",
        "zh-Hans": "尺寸调整 (5x ~ 20x)",
        "zh-Hant": "尺寸調整 (5x ~ 20x)",
    },
    "오류 정정 레벨 (L, M, Q, H)": {
        "ko": "오류 정정 레벨 (L, M, Q, H)",
        "en": "Error Correction Level (L, M, Q, H)",
        "ja": "エラー訂正レベル (L, M, Q, H)",
        "de": "Fehlerkorrekturlevel (L, M, Q, H)",
        "es": "Nivel de corrección de errores (L, M, Q, H)",
        "fr": "Niveau de correction d'erreur (L, M, Q, H)",
        "zh-Hans": "纠错级别 (L, M, Q, H)",
        "zh-Hant": "錯誤更正等級 (L, M, Q, H)",
    },
    "클립보드 복사": {
        "ko": "클립보드 복사",
        "en": "Copy to Clipboard",
        "ja": "クリップボードにコピー",
        "de": "In die Zwischenablage kopieren",
        "es": "Copiar al portapapeles",
        "fr": "Copier dans le presse-papiers",
        "zh-Hans": "复制到剪贴板",
        "zh-Hant": "複製到剪貼板",
    },
    "macOS 공유 서비스": {
        "ko": "macOS 공유 서비스",
        "en": "macOS Sharing Services",
        "ja": "macOS共有サービス",
        "de": "macOS Sharing-Dienste",
        "es": "Servicios de uso compartido de macOS",
        "fr": "Services de partage macOS",
        "zh-Hans": "macOS 共享服务",
        "zh-Hant": "macOS 共享服務",
    },
    "생성 히스토리": {
        "ko": "생성 히스토리",
        "en": "Generation History",
        "ja": "生成履歴",
        "de": "Generierungsverlauf",
        "es": "Historial de generación",
        "fr": "Historique de génération",
        "zh-Hans": "生成历史",
        "zh-Hant": "生成歷史記錄",
    },
}

LANG_MAP = {
    'en': 'en',
    'ko': 'ko',
    'ja': 'ja',
    'de': 'de',
    'es': 'es',
    'fr': 'fr',
    'zh-Hans': 'zh-Hans',
    'zh-Hant': 'zh-Hant',
}


def escape_string(s):
    if s is None:
        return ""
    return s.replace('\\', '\\\\').replace('"', '\\"').replace('\n', '\\n').replace('\t', '\\t')


def load_existing_strings(strings_file):
    """기존 .strings 파일에서 키-값 쌍을 파싱하여 딕셔너리로 반환"""
    existing = {}
    if not os.path.exists(strings_file):
        return existing

    with open(strings_file, 'r', encoding='utf-8') as f:
        content = f.read()

    pattern = re.compile(r'"((?:[^"\\]|\\.)*)"\s*=\s*"((?:[^"\\]|\\.)*)"\s*;')
    for match in pattern.finditer(content):
        key = match.group(1)
        value = match.group(2)
        existing[key] = value

    return existing


def merge_and_write_strings(strings_file, lang_folder, existing, new_entries):
    """기존 .strings 파일에 새 번역을 추가하거나 업데이트"""
    merged = dict(existing)
    added_count = 0

    for key, value in new_entries.items():
        if key not in merged:
            merged[key] = value
            added_count += 1

    # 파일 쓰기
    base_name = os.path.splitext(os.path.basename(strings_file))[0]
    with open(strings_file, 'w', encoding='utf-8') as f:
        f.write(f'/* {base_name}.strings ({lang_folder}) */\n')
        f.write(f'/* Auto-generated - Settings UI translations */\n\n')
        for key in sorted(merged.keys()):
            value = merged[key]
            f.write(f'"{escape_string(key)}" = "{escape_string(value)}";\n')

    return added_count


def translate_settings_strings():
    print('nowQRGen Settings UI 문자열 번역 중...\n')

    for lang, lang_folder in LANG_MAP.items():
        lproj_dir = os.path.join(RESOURCES_DIR, f'{lang_folder}.lproj')
        os.makedirs(lproj_dir, exist_ok=True)

        strings_file = os.path.join(lproj_dir, 'Localizable.strings')

        # 기존 파일 로드
        existing = load_existing_strings(strings_file)

        # 현재 언어에 대한 새 번역 수집
        new_entries = {}
        for ko_key, translations in SETTINGS_TRANSLATIONS.items():
            if lang in translations:
                new_entries[ko_key] = translations[lang]

        # 병합 및 저장
        added = merge_and_write_strings(strings_file, lang_folder, existing, new_entries)
        total = len(existing) + added
        print(f'  {lang_folder}.lproj/Localizable.strings: +{added} added ({total} total)')

    print('\n완료!')


def main():
    translate_settings_strings()


if __name__ == '__main__':
    main()
