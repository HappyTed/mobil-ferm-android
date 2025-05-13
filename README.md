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