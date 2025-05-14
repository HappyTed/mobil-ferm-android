#!/usr/bin/bash

if ! [ -d "$1" ] ; then
    echo "[! ] Передайте в качестве аргумента путь до директории с файлами приложения"
    exit 1
fi

PROJECT_DIR="$1"
DEST="$(pwd)"
LOGFILE="$DEST/build-apk.log"

echo "$PROJECT_DIR"

source .env

echo "[*] Сборка apk, вывод перенаправлен в $LOGFILE..."

docker run --rm -v $PROJECT_DIR:/home/app -w /home/app android-build:$TAG gradle assembleDebug --info --stacktrace > "$LOGFILE" 2>&1

cp "$PROJECT_DIR/app/build/outputs/apk/debug/app-debug.apk" "$(pwd)"
echo "[+] app-debug.apk сохранён в $DEST"

# gradle затянет зависимости, удалим все изменения 
echo "[*] Откат изменений в volumes..."
sudo git --git-dir="$PROJECT_DIR/.git" status
sudo git --git-dir="$PROJECT_DIR/.git" restore .
sudo git --git-dir="$PROJECT_DIR/.git clean -fd

echo "[✔] OK"