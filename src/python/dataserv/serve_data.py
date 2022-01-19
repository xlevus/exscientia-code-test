#!/usr/bin/env python3

import os
import json
import codecs
from http import server 
from typing import Any

"""
Dumb HTTP server to serve the data.json. Not intended to do anything, just acting
as a mock API server.

On startup will notify the codegen server of the schema.
"""

import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--port', default=8080, type=int)
parser.add_argument('data_dir', default='data')


class RequestHandler(server.SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/':
            # Make data the default path.
            self.path = '/compounds.json'

        return super().do_GET()


def serve(port: int) -> None:
    http = server.HTTPServer(('', port), RequestHandler)
    http.timeout = 1
    http.serve_forever()


if __name__ == '__main__':
    args = parser.parse_args()

    os.chdir(args.data_dir)

    serve(args.port)