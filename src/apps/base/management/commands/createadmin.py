import logging

from django.contrib.auth import get_user_model
from django.core.management import BaseCommand

User = get_user_model()
logger = logging.getLogger(__name__)


class Command(BaseCommand):
    help = 'This command create superuser'

    def add_arguments(self, parser) -> None:
        parser.add_argument("--username")
        parser.add_argument("--email")
        parser.add_argument("--password")

    def handle(self, *_, **options) -> None:
        if not User.objects.exists():
            user = User.objects.create_superuser(
                username=options.get('username'),
                email=options.get('email'),
                password=options.get('password')
            )
            logger.debug(f'Admin {user.username} was created.')
        else:
            logger.debug('Admin is already exists.')
