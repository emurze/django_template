import os
from pathlib import Path
from .base import BASE_DIR

LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
    "handlers": {
        "file": {
            "level": os.getenv('LOGGING_LEVEL'),
            "class": "logging.FileHandler",
            "filename": Path(BASE_DIR, "logs", "general.log"),
        },
        "stream": {
            "level": os.getenv('LOGGING_LEVEL'),
            "class": "logging.StreamHandler",
        },
    },
    "loggers": {
        "": {
            "level": os.getenv('LOGGING_LEVEL'),
            "handlers": [
                "stream",
                "file",
            ],
            'propagate': True,
        },
    },
}