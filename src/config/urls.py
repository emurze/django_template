import debug_toolbar
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('__debug__/', include(debug_toolbar.urls)),
    path('acccount/', include('apps.account.urls', namespace='account')),
    path('', include('apps.base.urls', namespace='base')),
]
