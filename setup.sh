#!/usr/bin/env bash
set -e

# Detect OS
OS="$(uname -s)"

install_from_source() {
    echo "Building from source..."

    # SDL3 core
    if [ ! -d SDL ]; then
        git clone https://github.com/libsdl-org/SDL.git -b SDL3
    fi
    cmake -S SDL -B SDL/build
    cmake --build SDL/build --target install

    # SDL3_image
    if [ ! -d SDL_image ]; then
        git clone https://github.com/libsdl-org/SDL_image.git
    fi
    cmake -S SDL_image -B SDL_image/build
    cmake --build SDL_image/build --target install

    # SDL3_ttf
    if [ ! -d SDL_ttf ]; then
        git clone https://github.com/libsdl-org/SDL_ttf.git
    fi
    cmake -S SDL_ttf -B SDL_ttf/build
    cmake --build SDL_ttf/build --target install

    # GoogleTest
    if [ ! -d googletest ]; then
        git clone https://github.com/google/googletest.git
    fi
    cmake -S googletest -B googletest/build
    cmake --build googletest/build --target install
}

case "$OS" in
    Darwin)
        echo "Detected macOS"
        if command -v brew >/dev/null 2>&1; then
            brew install sdl3_image sdl3_ttf googletest || install_from_source
        else
            install_from_source
        fi
        ;;
    Linux)
        echo "Detected Linux"
        if command -v apt >/dev/null 2>&1; then
            sudo apt update
            sudo apt install -y build-essential cmake git pkg-config \
                                libsdl3-dev libsdl3-image-dev libsdl3-ttf-dev \
                                libgtest-dev || install_from_source
        else
            install_from_source
        fi
        ;;
    *)
        echo "Unsupported OS. Falling back to source builds."
        install_from_source
        ;;
esac
