"""Minimal HTTP greeting service."""

import json
import os
from urllib.parse import parse_qs
from wsgiref.simple_server import make_server

HOST = "0.0.0.0"
DEFAULT_PORT = 8000
WELCOME_MESSAGE = "Welcome to the Git Flow project!"


def build_message(query_string: str) -> str:
    """Build a default or personalized greeting."""
    parameters = parse_qs(query_string)
    name = parameters.get("name", [""])[0]

    if name:
        return f"Hello, {name}! Welcome to the Git Flow project."

    return WELCOME_MESSAGE


def application(environment, start_response):
    """Serve the greeting endpoint."""
    if environment.get("PATH_INFO") != "/":
        body = json.dumps({"error": "Not found"}).encode("utf-8")
        start_response(
            "404 Not Found",
            [
                ("Content-Type", "application/json; charset=utf-8"),
                ("Content-Length", str(len(body))),
            ],
        )
        return [body]

    message = build_message(environment.get("QUERY_STRING", ""))
    body = json.dumps({"message": message}).encode("utf-8")
    start_response(
        "200 OK",
        [
            ("Content-Type", "application/json; charset=utf-8"),
            ("Content-Length", str(len(body))),
        ],
    )
    return [body]


def main() -> None:
    """Start the HTTP server."""
    port = int(os.getenv("PORT", str(DEFAULT_PORT)))

    with make_server(HOST, port, application) as server:
        print(f"Serving on http://{HOST}:{port}")
        server.serve_forever()


if __name__ == "__main__":
    main()
