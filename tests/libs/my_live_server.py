import socket

from django.contrib.staticfiles.testing import StaticLiveServerTestCase


class MyLiveServerTestCase(StaticLiveServerTestCase):
    host = socket.gethostbyname(socket.gethostname())
    port = 8081
