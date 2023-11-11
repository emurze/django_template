import abc
import time

import urllib3
from selenium import webdriver
from selenium.webdriver.remote.webdriver import WebDriver


class BaseDriverFactory(abc.ABC):
    @abc.abstractmethod
    def get_webdriver(self) -> WebDriver: ...


class ChromeDriverFactory(BaseDriverFactory):
    host = 'chrome'
    port = '4444'

    @classmethod
    def get_webdriver(cls):
        options = webdriver.ChromeOptions()
        return webdriver.Remote(
            f"http://{cls.host}:{cls.port}",
            options=options,
        )


def get_driver() -> WebDriver:
    """This function provides security from chrome container loading"""
    while True:
        try:
            driver = ChromeDriverFactory.get_webdriver()
        except urllib3.exceptions.MaxRetryError:
            time.sleep(.1)
        else:
            return driver