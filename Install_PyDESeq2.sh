#!/bin/bash

# Configuration
REPO_URL="https://github.com/euchrogene/PyDESeq2.git"
REPO_DIR="PyDESeq2"
EXE_FILE="PyDESeq2"
PIPELINE_ENTRY="$EXE_FILE => Analyze Differentially Expressed Genes (DEGs) using PyDESeq2."

TARGET_BIN="/usr/bin"
DATA_FILE="/usr/share/euchrogene_pipelines.txt"
VIEWER_SCRIPT="$TARGET_BIN/pipelines"

echo "Step 0: Checking for Python 3.12..."
if ! command -v python3.12 &> /dev/null; then
    echo "Python 3.12 not found. Installing via Deadsnakes PPA..."
    
    # Update and install prerequisite for adding repositories
    sudo apt-get update
    sudo apt-get install -y software-properties-common
    
    # Add the Deadsnakes PPA (Standard for multiple Python versions on Ubuntu)
    sudo add-apt-repository -y ppa:deadsnakes/ppa
    sudo apt-get update
    
    # Install Python 3.12 and common bioinformatics dependencies
    sudo apt-get install -y python3.12 python3.12-venv python3.12-dev
    
    echo "Python 3.12 installed successfully."
else
    echo "Python 3.12 is already installed."
fi

echo "Step 1: Downloading repository..."
# Clean up any previous failed attempts first
[ -d "$REPO_DIR" ] && rm -rf "$REPO_DIR"
git clone "$REPO_URL"

echo "Step 2 & 3: Installing executables..."
cd "$REPO_DIR" || exit
chmod +x *
sudo cp * "$TARGET_BIN/"

echo "Step 4: Removing the downloaded repository folder..."
cd ..
rm -rf "$REPO_DIR"

echo "Step 5: Updating the pipeline text database..."
sudo touch "$DATA_FILE"

# Add entry if it doesn't exist
if ! grep -q "$EXE_FILE" "$DATA_FILE"; then
    echo "$PIPELINE_ENTRY" | sudo tee -a "$DATA_FILE" > /dev/null
fi

# Sort the text file alphabetically
sudo sort -o "$DATA_FILE" "$DATA_FILE"

echo "Step 6: Ensuring the viewer script exists..."
sudo bash -c "cat <<EOF > $VIEWER_SCRIPT
#!/bin/bash
echo ''
echo '--- Registered EuchroGene Pipelines ---'
cat $DATA_FILE
echo '--------------------------------------'
EOF"

sudo chmod +x "$VIEWER_SCRIPT"

echo "Success! Installation complete and temporary files removed."
echo "To manage the list, you can manually edit $DATA_FILE."
