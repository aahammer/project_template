#!/bin/bash

# Python Project Template Setup Script
# Creates conda environment and installs all dependencies
# Usage: ./setup.sh [project_name] [python_version]

set -e

# Get parameters or use defaults
PROJECT_NAME=${1:-$(basename "$PWD")}
PYTHON_VERSION=${2:-"3.11"}

# Derived variables
PROJECT_DIR="$PWD"
CONDA_ENV_NAME="$PROJECT_NAME"
MODULE_NAME=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr '-' '_')

echo "Setting up Python project: $PROJECT_NAME"
echo "Project directory: $PROJECT_DIR"
echo "Python version: $PYTHON_VERSION"
echo "Conda environment: $CONDA_ENV_NAME"
echo "Module name: $MODULE_NAME"
echo ""

# Update template files with project-specific values
echo "Updating template files with project information..."

# Update environment.yml
sed -i.bak "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" environment.yml
sed -i.bak "s/{{PYTHON_VERSION}}/$PYTHON_VERSION/g" environment.yml
rm environment.yml.bak

# Update pyproject.toml
sed -i.bak "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" pyproject.toml
sed -i.bak "s/{{MODULE_NAME}}/$MODULE_NAME/g" pyproject.toml
sed -i.bak "s/{{PYTHON_VERSION}}/$PYTHON_VERSION/g" pyproject.toml
rm pyproject.toml.bak

# Update README.md
sed -i.bak "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" README.md
sed -i.bak "s/{{MODULE_NAME}}/$MODULE_NAME/g" README.md
rm README.md.bak

# Create project structure
echo "Creating project structure..."
mkdir -p "$MODULE_NAME"
mkdir -p tests
mkdir -p docs

# Create module __init__.py
cat > "$MODULE_NAME/__init__.py" << EOF
"""$PROJECT_NAME package."""

__version__ = "0.1.0"
EOF

# Create main module file
cat > "$MODULE_NAME/main.py" << EOF
"""Main module for $PROJECT_NAME."""


def hello() -> str:
    """Return a hello message."""
    return "Hello from $PROJECT_NAME!"


if __name__ == "__main__":
    print(hello())
EOF

# Create basic test file
cat > "tests/test_main.py" << EOF
"""Tests for $MODULE_NAME.main module."""

import pytest
from $MODULE_NAME.main import hello


def test_hello():
    """Test the hello function."""
    result = hello()
    assert isinstance(result, str)
    assert "$PROJECT_NAME" in result
EOF

# Create tests/__init__.py
touch "tests/__init__.py"

# Check if conda is available
if ! command -v conda &> /dev/null; then
    echo "Error: conda is not installed or not in PATH"
    echo "Please install conda/miniconda first"
    exit 1
fi

# Create conda environment if it doesn't exist
if ! conda env list | grep -q "$CONDA_ENV_NAME"; then
    echo "Creating conda environment from environment.yml..."
    conda env create -f environment.yml
    echo "✅ Conda environment created successfully"
else
    echo "✅ Conda environment '$CONDA_ENV_NAME' already exists"
fi

# Activate conda environment
echo "Activating conda environment: $CONDA_ENV_NAME"
eval "$(conda shell.bash hook)"
conda activate "$CONDA_ENV_NAME"

# Check if poetry is available in the environment
if ! command -v poetry &> /dev/null; then
    echo "Installing poetry in conda environment..."
    conda install -c conda-forge poetry -y
fi

# Install dependencies with Poetry
echo "Installing Python dependencies with Poetry..."
poetry install

echo ""
echo "✅ Setup completed successfully!"
echo ""
echo "Project structure created:"
echo "  $MODULE_NAME/          # Main package"
echo "  tests/                # Test files"
echo "  docs/                 # Documentation"
echo ""
echo "To use the environment:"
echo "  conda activate $CONDA_ENV_NAME"
echo ""
echo "To run tests:"
echo "  pytest"
echo ""
echo "To run your main module:"
echo "  python -m $MODULE_NAME.main"
