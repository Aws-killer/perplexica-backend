#!/bin/bash

# Script to create a configuration file at /home/perplexica/config.toml
# The configuration includes sections [GENERAL], [API_KEYS], and [API_ENDPOINTS]
# Values are sourced from environment variables if available; otherwise, default values are used.

# Define the output configuration file path
CONFIG_DIR="/home/perplexica"
CONFIG_FILE="$CONFIG_DIR/config.toml"

# Ensure the configuration directory exists
if [ ! -d "$CONFIG_DIR" ]; then
    echo "Directory '$CONFIG_DIR' does not exist. Creating it..."
    mkdir -p "$CONFIG_DIR"
    if [ $? -ne 0 ]; then
        echo "Failed to create directory '$CONFIG_DIR'. Please check your permissions."
        exit 1
    fi
fi

# Create or overwrite the configuration file
cat > "$CONFIG_FILE" <<EOL
[GENERAL]
PORT = ${PORT:-7860} # Port to run the server on
SIMILARITY_MEASURE = "${SIMILARITY_MEASURE:-cosine}" # "cosine" or "dot"

[API_KEYS]
OPENAI = "${OPENAI:-}" # OpenAI API key - sk-1234567890abcdef1234567890abcdef
GROQ = "${GROQ:-}" # Groq API key - gsk_1234567890abcdef1234567890abcdef
ANTHROPIC = "${ANTHROPIC:-}" # Anthropic API key - sk-ant-1234567890abcdef1234567890abcdef

[API_ENDPOINTS]
SEARXNG = "${SEARXNG:-http://localhost:32768}" # SearxNG API URL
OLLAMA = "${OLLAMA:-}" # Ollama API URL - http://host.docker.internal:11434
EOL

# Set appropriate permissions for the config file (optional)
chmod 600 "$CONFIG_FILE"

echo "Configuration file '$CONFIG_FILE' has been created successfully."