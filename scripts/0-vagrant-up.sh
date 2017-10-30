#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT="$( cd "$DIR/.." && pwd )"

(cd "$ROOT" && vagrant up)
