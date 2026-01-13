#!/bin/bash

# --- Configuration ---
APP_NAME="simker"
IMAGE_NAME="simker:latest" # Match this with your Dockerfile
CONFIG_DIR="$HOME/.config/$APP_NAME"
MAN_PAGE="simker.1"

# --- Colors ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Installing $APP_NAME Environment ===${NC}"

# 1. Check Dependencies
if ! command -v docker &> /dev/null; then
    echo -e "${RED}[ERROR] Docker is not installed. Please install Docker first.${NC}"
    exit 1
fi

# 2. Build Docker Image
echo -e "${BLUE}[1/4] Building Docker Image...${NC}"
docker build -t "$IMAGE_NAME" .
if [ $? -ne 0 ]; then
    echo -e "${RED}[ERROR] Docker build failed.${NC}"
    exit 1
fi
echo -e "${GREEN}      Docker image built successfully.${NC}"

# 3. Setup Config Directory
echo -e "${BLUE}[2/4] Setting up Configuration at $CONFIG_DIR...${NC}"
mkdir -p "$CONFIG_DIR"
cp docker-compose.yml "$CONFIG_DIR/"
echo -e "${GREEN}      Config files copied.${NC}"

# 4. Install Shell Integration
echo -e "${BLUE}[3/4] Configuring Shell Alias...${NC}"

# Define the function we want to inject
# We use a unique marker (# SIMKER_START) to ensure we don't duplicate it if installed twice
SHELL_FUNC="
# --- SIMKER START ---
simker() {
    local current_dir=\$(pwd)
    PROJECT_DIR=\"\$current_dir\" docker-compose -f $CONFIG_DIR/docker-compose.yml run --rm $IMAGE_NAME \"\$@\"
}
# --- SIMKER END ---
"

# Detect Shell
TARGET_RC=""
if [ -n "$ZSH_VERSION" ]; then
    TARGET_RC="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    TARGET_RC="$HOME/.bashrc"
else
    # Fallback usually to bashrc
    TARGET_RC="$HOME/.bashrc"
fi

# Append only if not already present
if grep -q "SIMKER START" "$TARGET_RC"; then
    echo -e "${GREEN}      Alias already exists in $TARGET_RC. Skipping.${NC}"
else
    echo "$SHELL_FUNC" >> "$TARGET_RC"
    echo -e "${GREEN}      Alias added to $TARGET_RC.${NC}"
fi

echo -e "${BLUE}=== Installation Complete! ===${NC}"
echo -e "Please run: ${GREEN}source $TARGET_RC${NC} to start using the tool."
echo -e "If the fonts seem undefined / strange, install FiraCode Nerd font, and set is as default to your terminal."
