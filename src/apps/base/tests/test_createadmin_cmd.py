import re
from io import StringIO

from django.contrib.auth import get_user_model
from django.test import TestCase

from django.core.management import call_command

User = get_user_model()
regex = re.compile('\S+')


class CreateAdminCommandTest(TestCase):
    @staticmethod
    def call_command(*args, **kwargs) -> bool:
        out = StringIO()
        call_command(
            "createadmin",
            stdout=out,
            stderr=StringIO(),
            *args,
            **kwargs,
        )
        cmd = ' '.join(regex.findall(out.getvalue()))

        if cmd == "You already have admin. Admin wasn't created.":
            return False
        else:
            return True

    # unittest
    def test_can_create_admin(self) -> None:
        cmd = self.call_command()
        self.assertTrue(cmd)

    # integration
    def test_cannot_create_admin_if_exists(self) -> None:
        User.objects.create_superuser(
            username='wef_wef',
            password='1234wef34',
        )
        cmd = self.call_command()
        self.assertFalse(cmd)
