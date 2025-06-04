#!/usr/bin/env bash

CMDLINE_TOOLS_VERSION="11076708_latest"
ANDROID_BUILD_TOOLS_VERSION=34.0.0
ANDROID_VERSION=34
ANDROID_HOME="/usr/local/android-sdk"
JDK_VERSION=24.0.1
NODEJS_VERSION=22.16.0
DRIVERS=("uiautomator2")

HELP="Use: sudo $0 [OPTION] [FLAG]
    install - for install dependecies:
       --all:   Default mode, install all dependecies: 
                 android dependences:
                  - cmdline tools (ver: $CMDLINE_TOOLS_VERSION)
                  - openjdk (ver: $JDK_VERSION)
                  - platform-tools (latest)
                 other:
                  - node.js with npm (ver: $NODEJS_VERSION)
                  - appium (latest)
                 appium drivers: ${DRIVERS[*]}
       --android: install only android dependecies
       --apium:   install node.js, npm, appium
       --drivers: install appium drivers 
    uninstall - for uninstal dependecies
    status  - check installed utils"

[ -f ".env" ] && source .env

function android_install() {
        # Установка зависимостей и SDK
        cd ${ANDROID_HOME} 
        wget -O sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-${CMDLINE_TOOLS_VERSION}.zip
        unzip sdk.zip
        rm -f sdk.zip
        cd cmdline-tools/bin

        # Установка необходимых компонентов SDK
        yes | ${ANDROID_HOME}/cmdline-tools/bin/./sdkmanager --sdk_root=${ANDROID_HOME} --update
        yes | ${ANDROID_HOME}/cmdline-tools/bin/./sdkmanager --sdk_root=${ANDROID_HOME} \
                "platform-tools" \
                "platforms;android-${ANDROID_VERSION}" \
                "build-tools;${ANDROID_BUILD_TOOLS_VERSION}"

        # ANDROID_HOME and ANDROID_SDK_ROOT envs:
        SETUP_BLOCK=$(cat <<'EOF'
# >>> Android SDK setup >>>
export ANDROID_SDK_ROOT="/usr/local/android-sdk"
export ANDROID_HOME="$ANDROID_SDK_ROOT"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools"
# <<< Android SDK setup <<<
EOF
)

        if ! grep -q 'ANDROID_SDK_ROOT' ~/.bashrc ; then
                echo "$SETUP_BLOCK" >> ~/.bashrc
        fi

        echo "[+] Компоненты android-sdk установлены в $ANDROID_HOME"
}

function openjdk_install() {
        cd ${ANDROID_HOME}
        local arch
        arch="$(uname -m)"
        case "$arch" in 
                "x86_64") 
                        wget -O openjdk.tar.gz "https://download.java.net/java/GA/jdk${JDK_VERSION}/24a58e0e276943138bf3e963e6291ac2/9/GPL/openjdk-${JDK_VERSION}_linux-aarch64_bin.tar.gz"
                ;;
        esac
        tar xvf openjdk.tar.gz
        rm -f openjdk.tar.gz

        echo "[+] Компоненты openjdk установлены в ${ANDROID_HOME}"
}

function appium_install() {

        # from: https://nodejs.org/en/download
        cd ${ANDROID_HOME}

        # Download and install nvm:
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

        # in lieu of restarting the shell
        \. "$HOME/.nvm/nvm.sh"

        # Download and install Node.js:
        nvm install 22

        npm install -g appium

        echo "[+] node.js, npm и appium установлены"
}

function drivers_install() {
        for driver in ${DRIVERS[@]} ; do
                appium driver install "$driver"
        done
        appium plugin install inspector
        echo "[+] Appium  drivers установлены"
}

function status() {
        source ~/.bashrc
        export NVM_DIR="$HOME/.nvm"
        # загружаем nvm
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        # загружаем автокомплит (опционально)
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
        
        # Verify the Node.js version:
        echo "Node.js version:"
        node -v # Should print "v22.16.0".
        nvm current # Should print "v22.16.0".

        # Verify npm version:
        echo "Npm version:"
        npm -v # Should print "10.9.2".

        echo "Appium version:"
        appium -v

        echo "Appium drivers:"
        appium driver list
}

function install() {        
        mkdir -p ${ANDROID_HOME}
        for arg in "$@" ; do
                case "$arg" in
                        --all) android_install ; appium_install ; drivers_install ;;
                        --android) android_install ; openjdk_install ;;
                        --appium) appium_install ;;
                        --drivers) drivers_install ;;
                        *) echo "Unknow flag '$arg'" ; echo "$HELP" ;;
                esac
        done
        status
}

function clear() {
        rm -rf "$ANDROID_HOME"
        # TODO: что ещё нужно удалять?
}


case "$1" in 
#  install) if ! install $@ ; then clear ; fi ;;
 install) 
        shift 1 ;
        install "$@"
;;
 uninstall) clear ;;
 status) status ;;
 *) echo "$HELP" ;;
esac

echo "Обязательно выполните source ~/.bashrc после установки!"
