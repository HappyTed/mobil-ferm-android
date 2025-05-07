https://appium.io/docs/en/latest/quickstart/uiauto2-driver/

### Android-SDK-комплект¶
- Самый простой способ настроить требования Android SDK — загрузить Android Studio . Нам нужно использовать его менеджер SDK ( Настройки -> Языки и фреймворки -> Android SDK ), чтобы загрузить следующие элементы:
1. Платформа Android SDK (выберите любую платформу Android, которую вы хотите автоматизировать, например, API уровня 30)
2. Android SDK Platform-Tools
- При желании вы также можете загрузить эти элементы без Android Studio: **(я предпочитаю этот способ)**
1. Платформу Android SDK можно загрузить с помощью sdkmanager встроенных в [Android инструментов командной строки](https://developer.android.com/studio#command-line-tools-only).
2. [Android SDK Platform-Tools](https://developer.android.com/tools/releases/platform-tools)


### установить последнюю версию Open JDK 
с сайта oracle https://jdk.java.net/24/

### переменные окруженич

1. ANDROID_HOME

добавить в ~/.bashrc
должна указывать на путь до разархивированного Android SDK Platform-Tools: `export ANDROID_HOME="$HOME/<путь_до_дриектории>/android-sdk/platform-tools-latest-linux"`

2. JAVA_HOME
добавить в ~/.bashrc
должна указывать на путь до разархивированного JDK `export JAVA_HOME="$HOME/<путь_до_дриектории>/android-sdk/openjdk-24.0.1_linux-aarch64_bin/jdk-24.0.1"`

3. source ~/.bashrc


### bundletool.jar
download the binary from https://github.com/google/bundletool/releases/ and store it to ...(/usr/local/bin или в любой другой путь из перемнной $PATH)



### проверить adb: 

`adb devices`

ожидаем:
```shell
/$ adb devices
List of devices attached
RF8WC0FV4JH     device
```