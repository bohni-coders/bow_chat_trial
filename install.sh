#!/bin/bash

# Check if a package is installed (Linux)
is_installed_linux() {
    dpkg -s "$1" &> /dev/null
}

# Check if a package is installed (macOS)
is_installed_macos() {
    brew list "$1" &> /dev/null
}

# Function to install dependencies on Ubuntu/Debian
install_deps_linux() {
    echo "Installing dependencies for Linux..."
    sudo apt-get update -y

    # List of packages to be installed
    local packages=(gnupg2 build-essential autoconf bison libssl-dev libyaml-dev \
        libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev \
        nodejs redis-server postgresql postgresql-contrib libpq-dev yarn)

    for pkg in "${packages[@]}"; do
        if is_installed_linux "$pkg"; then
            echo "$pkg is already installed, skipping..."
        else
            sudo apt-get install -y "$pkg"
        fi
    done
}

# Function to install dependencies on macOS
install_deps_macos() {
    echo "Installing dependencies for macOS..."

    # List of packages to be installed
    local packages=(rbenv ruby-build node yarn postgresql redis)

    for pkg in "${packages[@]}"; do
        if is_installed_macos "$pkg"; then
            echo "$pkg is already installed, skipping..."
        else
            brew install "$pkg"
        fi
    done

    brew services start postgresql
    brew services start redis
}

# Function to install dependencies on Windows (WSL)
install_deps_windows() {
    echo "Installing dependencies for Windows WSL..."
    install_deps_linux
}

# Detecting the Operating System
OS="$(uname -s)"
case "$OS" in
    Linux*)     OS=Linux;;
    Darwin*)    OS=Mac;;
    MINGW*|MSYS*|CYGWIN*) OS=Windows;;
    *)          echo "Unsupported OS: $OS"; exit 1;;
esac

# Install dependencies based on OS
if [ "$OS" = "Linux" ]; then
    install_deps_linux
elif [ "$OS" = "Mac" ]; then
    install_deps_macos
elif [ "$OS" = "Windows" ]; then
    install_deps_windows
fi

# Check if Ruby is installed
if ! which rbenv > /dev/null; then
    rbenv install 3.0.0
    rbenv global 3.0.0
else
    echo "Ruby is already installed, skipping..."
fi

# Install Ruby and JavaScript dependencies
bundle install
yarn install


# Create and setup the database
#rails db:create db:migrate db:seed

# Start the local server
bundle exec rails server

# End of script
echo "Chatwoot local server setup complete!"
