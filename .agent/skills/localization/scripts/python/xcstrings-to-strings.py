#!/usr/bin/env python3
"""
xcstrings 파일을 언어별 .lproj/xxx.strings 파일로 변환하는 스크립트
"""
import json
import os

LANG_MAP = {
    'en': 'en',
    'ko': 'ko',
    # 향후 추가 예정: ja, de, es, fr, zh-Hans, zh-Hant
}

def escape_string(s):
    if s is None:
        return ""
    return s.replace('\\', '\\\\').replace('"', '\\"').replace('\n', '\\n').replace('\t', '\\t')

def xcstrings_to_strings(xcstrings_path, output_dir):
    base_name = os.path.splitext(os.path.basename(xcstrings_path))[0]

    with open(xcstrings_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    source_lang = data.get('sourceLanguage', 'en')
    strings = data.get('strings', {})

    lang_strings = {lang: {} for lang in LANG_MAP.keys()}

    for key, entry in strings.items():
        localizations = entry.get('localizations', {})
        for lang in LANG_MAP.keys():
            if lang in localizations:
                loc_data = localizations[lang]
                string_unit = loc_data.get('stringUnit', {})
                value = string_unit.get('value')
                state = string_unit.get('state', 'new')
                if value and state in ('translated', 'new'):
                    lang_strings[lang][key] = value
            else:
                if lang == source_lang:
                    lang_strings[lang][key] = key

    for lang, lang_folder in LANG_MAP.items():
        lproj_dir = os.path.join(output_dir, f'{lang_folder}.lproj')
        os.makedirs(lproj_dir, exist_ok=True)

        strings_file = os.path.join(lproj_dir, f'{base_name}.strings')
        with open(strings_file, 'w', encoding='utf-8') as f:
            f.write(f'/* {base_name}.strings ({lang}) */\n')
            f.write(f'/* Auto-generated from {base_name}.xcstrings */\n\n')
            for key in sorted(lang_strings[lang].keys()):
                value = lang_strings[lang][key]
                f.write(f'"{escape_string(key)}" = "{escape_string(value)}";\n')

        count = len(lang_strings[lang])
        print(f'  {lang_folder}.lproj/{base_name}.strings: {count} strings')

    return len(strings)

def main():
    resources_dir = 'fQRGen/fQRGen'

    xcstrings_files = [
        os.path.join(resources_dir, 'Localizable.xcstrings'),
    ]

    print('Converting xcstrings to .strings files...\n')

    for xcstrings_path in xcstrings_files:
        if os.path.exists(xcstrings_path):
            print(f'Processing: {os.path.basename(xcstrings_path)}')
            total = xcstrings_to_strings(xcstrings_path, resources_dir)
            print(f'  Total keys: {total}\n')
        else:
            print(f'File not found: {xcstrings_path}')
            print(f'  -> Xcode에서 String Catalog 파일을 먼저 생성하세요.')

    print('Done!')

if __name__ == '__main__':
    main()
