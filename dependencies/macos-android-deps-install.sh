#!/usr/bin/env bash

CMDLINE_TOOLS_VERSION="11076708_latest"
ANDROID_BUILD_TOOLS_VERSION=34.0.0
ANDROID_VERSION=34
ANDROID_HOME="$HOME/Library/Android/sdk"
JDK_VERSION=24.0.1
NODEJS_VERSION=22.16.0
DRIVERS=("uiautomator2")

HELP="Use: $0 [OPTION] [FLAG]
    install - for install dependencies:
       --all:   Default mode, install all dependencies:
                 android dependencies:
                  - cmdline tools (ver: $CMDLINE_TOOLS_VERSION)
                  - openjdk (ver: $JDK_VERSION)
                  - platform-tools (latest)
                 other:
                  - node.js with npm (ver: $NODEJS_VERSION)
                  - appium (latest)
                 appium drivers: ${DRIVERS[*]}
       --android: install only android dependencies
       --appium:  install node.js, npm, appium
       --drivers: install appium drivers 
    uninstall - for uninstall dependencies
    status  - check installed utils"

[ -f ".env" ] && source .env

function android_install() {
        mkdir -p "$ANDROID_HOME/cmdline-tools"
        cd "$ANDROID_HOME/cmdline-tools"

        curl -o sdk.zip "https://dl.google.com/android/repository/commandlinetools-mac-${CMDLINE_TOOLS_VERSION}.zip"
        unzip sdk.zip -d latest
        rm -f sdk.zip

        yes | "$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager" --sdk_root="$ANDROID_HOME" --update
        yes | "$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager" --sdk_root="$ANDROID_HOME" \
                "platform-tools" \
                "platforms;android-${ANDROID_VERSION}" \
                "build-tools;${ANDROID_BUILD_TOOLS_VERSION}"

        SETUP_BLOCK=$(cat <<'EOF'
# >>> Android SDK setup >>>
export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
export ANDROID_HOME="$ANDROID_SDK_ROOT"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools"
# <<< Android SDK setup <<<
EOF
)

        if ! grep -q 'ANDROID_SDK_ROOT' ~/.bashrc && [ -f ~/.bashrc ]; then
                echo "$SETUP_BLOCK" >> ~/.bashrc
        fi

        if [ -f ~/.zshrc ]; then
                echo "$SETUP_BLOCK" >> ~/.zshrc
        fi

        echo "[+] Android SDK зависимости установлены в $ANDROID_HOME"
}

function appium_install() {
        export NVM_DIR="$HOME/.nvm"
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
        \. "$NVM_DIR/nvm.sh"

        nvm install $NODEJS_VERSION
        nvm use $NODEJS_VERSION

        npm install -g appium

        echo "[+] node.js, npm и appium установлены"
}

function drivers_install() {
        for driver in "${DRIVERS[@]}"; do
                appium driver install "$driver"
        done
        appium plugin install inspector
        echo "[+] Appium драверы установлены"
}

function status() {
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

        echo "Node.js version:"
        node -v
        nvm current

        echo "Npm version:"
        npm -v

        echo "Appium version:"
        appium -v

        echo "Appium drivers:"
        appium driver list
}

function install() {
        mkdir -p "$ANDROID_HOME"
        for arg in "$@" ; do
                case "$arg" in
                        --all) android_install ; appium_install ; drivers_install ;;
                        --android) android_install ;;
                        --appium) appium_install ;;
                        --drivers) drivers_install ;;
                        *) echo "Unknown flag '$arg'" ; echo "$HELP" ;;
                esac
        done
        status
}

function clear() {
        rm -rf "$ANDROID_HOME"
        echo "[+] Android SDK removed from $ANDROID_HOME"
}

case "$1" in
 install)
        shift 1
        install "$@"
;;
 uninstall) clear ;;
 status) status ;;
 *) echo "$HELP" ;;
esac

echo "Не забудь выполнить 'source ~/.bashrc' и 'source ~/.zshrc' после установки!"