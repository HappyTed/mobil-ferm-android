import unittest
from appium import webdriver
from appium.options.android import UiAutomator2Options
from pathlib import Path

path_to_app = str(Path.home() / "Documents/mobil-ferm-android/mobileApps/app-debug.apk")

capabilities = {
    "platformName": "Android",
    "automationName": "UiAutomator2",
    "deviceName": "09859373A5004645",  # заменить на свой
    "app": path_to_app
}

appium_server_url = 'http://localhost:4723'

class TestAppium(unittest.TestCase):
    def setUp(self) -> None:
        options = UiAutomator2Options().load_capabilities(capabilities)
        self.driver = webdriver.Remote(command_executor=appium_server_url, options=options)

    def tearDown(self) -> None:
        if self.driver:
            self.driver.quit()

    def test_save_screenshot(self) -> None:
        file_name = 'screenshot.png'
        self.driver.save_screenshot(file_name)


if __name__ == '__main__':
    unittest.main()
