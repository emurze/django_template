from django.urls import path

from apps.base.views import test

app_name = 'base'

urlpatterns = [
    path('test/', test, name='test'),
]
