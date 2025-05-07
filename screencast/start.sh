#!/usr/bin/bash

# screenrecordэто внутренний исполняемый файл Android, который выводит содержимое экрана в файл, а ffplayffmpeg может воспроизводить поток в кодировке H.264 из stdin
# Возможно, вам придется немного подвигать экран, прежде чем вы что-то увидите:

adb exec-out screenrecord --output-format=h264 - | ffplay -framerate 60 -probesize 32 -sync video  -