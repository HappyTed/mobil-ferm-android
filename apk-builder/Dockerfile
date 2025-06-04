# source: https://habr.com/ru/articles/465193/
# ======
# Т.к. основным инструментом для сборки Android-проектов является Gradle, 
# и по счастливому стечению обстоятельств есть официальный Docker-образ 
# мы решили за основу взять именно его с нужной нам версией Gradle
FROM gradle:8.7-jdk17

# Задаем переменные с локальной папкой для Android SDK и 
# версиями платформы и инструментария
ARG ANDROID_BUILD_TOOLS_VERSION
ARG CMDLINE_TOOLS_VERSION
ARG ANDROID_VERSION

ENV ANDROID_HOME="/usr/local/android-sdk" \
    PATH="$PATH:/usr/local/android-sdk/cmdline-tools/latest/bin:/usr/local/android-sdk/platform-tools"

# Установка зависимостей и SDK
RUN mkdir -p ${ANDROID_HOME} \
    && cd ${ANDROID_HOME} \
    && curl -o sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-${CMDLINE_TOOLS_VERSION}.zip \
    && unzip sdk.zip \
    && rm sdk.zip \
    && cd cmdline-tools/bin

#   прокидываем лицензии:
# sdkmanager для установки требует принять условия лицензионного соглашения. 
# В Docker-контейнере или CI/CD-пайплайне возможности нет интерактивно принять соглашение лицензии, и установка завалится с ошибкой, если лицензии не приняты заранее.

# Мы симулируем, как будто пользователь уже принял лицензионное соглашение. Это "отпечатки согласия" с конкретными версиями соглашений:
# Нужно вручную принять лицензию на своей машине и скопировать новые файлы из ~/.android/licenses.

# Если Google обновит условия лицензионных соглашений (это бывает), то cтарая хеш-сумма может больше не работать.

COPY ./licenses/ ${ANDROID_HOME}/licenses/

# Установка необходимых компонентов SDK
RUN yes | ${ANDROID_HOME}/cmdline-tools/bin/./sdkmanager --sdk_root=${ANDROID_HOME} --update \
    && yes | ${ANDROID_HOME}/cmdline-tools/bin/./sdkmanager --sdk_root=${ANDROID_HOME} \
        "platform-tools" \
        "platforms;android-${ANDROID_VERSION}" \
        "build-tools;${ANDROID_BUILD_TOOLS_VERSION}"