# https://jupyter-docker-stacks.readthedocs.io/en/latest/index.html

# Mount the project root, derived from this script's own location rather than
# the caller's cwd, so the launchers work from any subdirectory.
project_root=$(dirname -- "$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")")

# /home/jovyan is the notebook user's home in this image; the mount has to land
# inside it for the server to be able to write.
work_dir="/home/jovyan/work"

# Pin the image to the host's native architecture. A cached amd64 image runs
# under emulation on Apple Silicon, where the ipykernel process starts but never
# answers kernel_info, so the browser sits on "Connecting" forever.
case "$(uname -m)" in
    arm64 | aarch64) platform="linux/arm64" ;;
    *) platform="linux/amd64" ;;
esac

args=(
    "-it"
    "--rm"
    "--platform" "${platform}"
    "-u" "root"
    "-e" "NB_UID=$(id -u)"
    "-e" "NB_GID=$(id -g)"
    "-e" "GRANT_SUDO=1"
    "-p" "8888:8888"
    "-v" "${project_root}:${work_dir}"
    "-w" "${work_dir}"
    "quay.io/jupyter/base-notebook:latest"
)
