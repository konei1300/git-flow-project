"""Minimal HTTP greeting service."""

import json
import os
from wsgiref.simple_server import make_server

HOST = "0.0.0.0"
DEFAULT_PORT = 8000
WELCOME_MESSAGE = "Welcome to the Git Flow project!"


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

    body = json.dumps({"message": WELCOME_MESSAGE}).encode("utf-8")
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
