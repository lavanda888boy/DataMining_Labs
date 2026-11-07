#!/bin/bash

set -euxo pipefail

script_dir=$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")
source -- "${script_dir}/_container-args.sh"

podman run --userns=keep-id "${args[@]}"
