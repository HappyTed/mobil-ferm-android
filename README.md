# ADB

список доступных устройств:
```
adb devices
```

имя устройства по id:
```
adb -s 09859373A5004645 shell getprop ro.product.model
```

adb restart:
```
adb kill-server
adb start-server
```

# Развернуть appium-сервер локально

## 1 Зависимости для appium (+adnroid real device):

https://appium.io/docs/en/latest/quickstart/requirements/

1) adb на хост машине с возможность получения подключенных устройств (`adb devices`)
установка: `sudo apt install android-tools-adb -y`

2) Node.js одной из версий ^14.17.0 || ^16.13.0 || >=18.0.0
установка: https://nodejs.org/en/download

3) npm не ниже 8 версии
(обычно устанавливается с node.js) `npm -v`

## 2 Установка Appium
https://appium.io/docs/en/latest/quickstart/install/

установка: `npm install -g appium`

запуск: `appium`

версия: `appium -v`

## 3 Установка драйверов appium

https://appium.io/docs/en/latest/ecosystem/drivers/

`appium driver install <installation key>`


драйвер для android: `UiAutomator2`, установка: `appium driver install uiautomator2`


### inspector (веб-интерфейс)
установка:
```
appium plugin install inspector
```

запуск сервера с инспектором:
```
appium --use-plugins=inspector --allow-cors
```

доступен: `http://localhost:4723/inspector` 

## 4 android зависимости

https://appium.io/docs/en/latest/quickstart/uiauto2-driver/

### Android-SDK-комплект¶
- Самый простой способ настроить требования Android SDK — загрузить Android Studio . Нам нужно использовать его менеджер SDK ( Настройки -> Языки и фреймворки -> Android SDK ), чтобы загрузить следующие элементы:
1. Платформа Android SDK (выберите любую платформу Android, которую вы хотите автоматизировать, например, API уровня 30)
2. Android SDK Platform-Tools
- При желании вы также можете загрузить эти элементы без Android Studio:
1. Платформу Android SDK можно загрузить с помощью sdkmanagerвстроенных в [Android инструментов командной строки](https://developer.android.com/studio#command-line-tools-only).
2. [Android SDK Platform-Tools](https://developer.android.com/tools/releases/platform-tools)


установить последнюю версию JDK (с сайта oracle)

### переменные окруженич

1. ANDROID_HOME

добавить в ~/.bashrc
должна указывать на путь до разархивированного Android SDK Platform-Tools: `export ANDROID_HOME="$HOME/<путь_до_дриектории>/android-sdk/platform-tools-latest-linux"`

2. JAVA_HOME
добавить в ~/.bashrc
должна указывать на путь до разархивированного JDK `export JAVA_HOME="$HOME/<путь_до_дриектории>/android-sdk/openjdk-24.0.1_linux-aarch64_bin/jdk-24.0.1"`

3. source ~/.bashrc


### bundletool.jar
download the binary from https://github.com/google/bundletool/releases/ and store it to /usr/local/bin 
или в любой другой путь из перемнной $PATH


## 5 Запуск appium сервера

просто запустить `appium`

примерный вывод:
```
[Appium] Welcome to Appium v2.18.0 (REV 977563e97ddc66facf3a8e31c6cff01d236f09bd)
[Appium] The autodetected Appium home path: /home/user/.appium
[Appium] Attempting to load driver uiautomator2...
[Appium] Requiring driver at /home/user/.appium/node_modules/appium-uiautomator2-driver/build/index.js
[Appium] AndroidUiautomator2Driver has been successfully loaded in 0.253s
[Appium] Appium REST http interface listener started on http://0.0.0.0:4723
[Appium] You can provide the following URLs in your client code to connect to this server:
        http://127.0.0.1:4723/ (only accessible from the same host)
        http://your_ip:4723/
        http://your_ip:4723/
[Appium] Available drivers:
[Appium]   - uiautomator2@4.2.3 (automationName 'UiAutomator2')
[Appium] No plugins have been installed. Use the "appium plugin" command to install the one(s) you want to use.
```




ну а дальше установка зависимостей из tests/requirements.txt и запуск test_example.py....