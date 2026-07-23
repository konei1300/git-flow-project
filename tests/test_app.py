"""Tests for greeting message construction."""

import unittest

from app import WELCOME_MESSAGE, build_message


class BuildMessageTests(unittest.TestCase):
    """Validate default and personalized greeting messages."""

    def test_returns_default_message_without_name(self) -> None:
        self.assertEqual(build_message(""), WELCOME_MESSAGE)

    def test_returns_personalized_message(self) -> None:
        self.assertEqual(
            build_message("name=Ibrahim"),
            "Hello, Ibrahim! Welcome to the Git Flow project.",
        )

    def test_trims_surrounding_whitespace(self) -> None:
        self.assertEqual(
            build_message("name=%20%20Ibrahim%20%20"),
            "Hello, Ibrahim! Welcome to the Git Flow project.",
        )

    def test_returns_default_message_for_whitespace_only(self) -> None:
        self.assertEqual(build_message("name=%20%20%20"), WELCOME_MESSAGE)


if __name__ == "__main__":
    unittest.main()
