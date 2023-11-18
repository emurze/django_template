import abc

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
    """Driver Factory"""
    return ChromeDriverFactory.get_webdriver()
