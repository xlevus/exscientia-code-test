#!/bin/bash

set -ex

mix local.hex --force
mix deps.get
mix ecto.migrate
mix phx.server
