from pathlib import Path
from .base import BASE_DIR

from debug_toolbar.panels.logging import collector

LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
    "handlers": {
        "file": {
            "level": "DEBUG",
            "class": "logging.FileHandler",
            "filename": Path(BASE_DIR.parent, "logs", "general.log"),
        },
        "stream": {
            "level": "DEBUG",
            "class": "logging.StreamHandler",
        },
        'debug_toolbar_log': {
            'level': 'DEBUG',
            'class': 'debug_toolbar.panels.logging.ThreadTrackingHandler',
            'collector': collector,
        },
    },
    "loggers": {
        "": {
            "level": "DEBUG",
            "handlers": [
                "debug_toolbar_log",
                "stream",
                "file",
            ],
        },
    },
}
