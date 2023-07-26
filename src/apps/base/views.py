import logging

from django.core.handlers.wsgi import WSGIRequest
from django.http import HttpResponse
from django.shortcuts import render

logger = logging.getLogger(__name__)


def test(request: WSGIRequest) -> HttpResponse:
    logger.debug('TEST VIEW')
    return render(request, 'test.html', {})
