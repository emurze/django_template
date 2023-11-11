from typing import TypeVar

T = TypeVar('T')


def mixin_for(_: T) -> T:
    return object
