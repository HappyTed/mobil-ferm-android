import unittest
from appium import webdriver
from appium.options.android import UiAutomator2Options
from pathlib import Path
from conf import *
from uuid import uuid4
import time

path_to_app = "/home/fromAndrey.apk" # путь к apk. Должен лежать рядом с appium сервером
app_name = "com.altcraft.altcraftmsdkv2"

capabilities = {
    "platformName": "Android",
    "automationName": "UiAutomator2",
    "deviceName": "Android", 
}

appium_server_url = f'http://{APPIUM_HOST}:{APPIUM_PORT}'

class TestAppium(unittest.TestCase):
    def setUp(self) -> None:
        options = UiAutomator2Options().load_capabilities(capabilities)
        self.driver = webdriver.Remote(command_executor=appium_server_url, options=options)
        
        if not self.driver.is_app_installed(path_to_app):
            _ = self.driver.install_app(path_to_app)

        

    def tearDown(self) -> None:
        if self.driver:
            self.driver.quit()

    def test_save_screenshot(self) -> None:
        uid = str(uuid4())
        file_name = uid+'screenshot.png'
        self.driver.activate_app(app_name)
        time.sleep(10)
        self.driver.save_screenshot(file_name)


if __name__ == '__main__':
    unittest.main()
