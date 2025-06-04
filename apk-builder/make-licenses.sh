#!/bin/bash
set -e

source .env

# === Параметры ===
SDK_ROOT="$(pwd)/tmp"
DEST_DIR="$SDK_ROOT/../licenses" # директория для сохранения лицензий
SDK_URL="https://dl.google.com/android/repository/commandlinetools-linux-${CMDLINE_TOOLS_VERSION}.zip"

if [ -d "$SDK_ROOT" ] ; then
    rm -rf "$SDK_ROOT"
fi

if [ -d "$DEST_DIR" ] ; then
    rm -rf "$DEST_DIR"
fi

function cleanup() {
  echo "[*] Очистка временных файлов..."
  rm -rf "$SDK_ROOT"
}
trap cleanup EXIT INT TERM

# === Загрузка и установка cmdline-tools ===
echo "[*] Скачивание и установка command line tools..."
mkdir -p "$SDK_ROOT"
cd "$SDK_ROOT"
curl -sSL -o sdk.zip "$SDK_URL"
unzip -q sdk.zip
rm sdk.zip
cd "cmdline-tools/bin"

# === Установка sdkmanager в PATH ===
export ANDROID_SDK_ROOT="$SDK_ROOT"
export PATH="$SDK_ROOT/cmdline-tools/bin:$PATH"

# === Обновление и запуск лицензий ===
echo "[*] Обновление SDK Manager..."
yes | ./sdkmanager --sdk_root="$SDK_ROOT" --update

echo "[*] Запуск интерактивного подтверждения лицензий..."
./sdkmanager --sdk_root="$SDK_ROOT" --licenses

# === Копирование лицензий ===
mkdir -p "$DEST_DIR"
cp -r "$SDK_ROOT/licenses/*" "$DEST_DIR"

echo "[+] Лицензии сохранены в $DEST_DIR/licenses"

echo "[✔] Готово. Файлы лицензий можно использовать в Docker."
