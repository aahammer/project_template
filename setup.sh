#!/bin/bash

# Python Project Template Setup Script
# Creates conda environment and installs all dependencies
#
# PREREQUISITES:
# - conda (miniconda/anaconda) must be installed and available in PATH
#
# USAGE:
#   ./setup.sh [project_name] [python_version]
#
# PARAMETERS:
#   project_name   : Name of your project (optional, defaults to current folder name)
#   python_version : Python version to use (optional, defaults to 3.11)
#
# EXAMPLES:
#   # Use defaults (folder name + Python 3.11):
#   ./setup.sh
#
#   # Specify project name only (uses Python 3.11):
#   ./setup.sh my_awesome_project
#
#   # Specify both project name and Python version:
#   ./setup.sh my_awesome_project 3.12
#   ./setup.sh data_analysis_tool 3.10
#
# WHAT THIS SCRIPT DOES:
# 1. Updates template files (pyproject.toml, environment.yml, README.md) with your project info
# 2. Creates project directory structure (package, tests, docs folders)
# 3. Creates conda environment with specified Python version
# 4. Installs poetry and all dependencies

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

# Clean up template files to keep project clean
echo "Cleaning up template files..."
rm -f TEMPLATE_README.md
rm -f setup.sh

echo ""
echo "✅ Setup completed successfully!"
echo ""
echo "Project '$PROJECT_NAME' is ready for development!"
echo ""
echo "Project structure created:"
echo "  $MODULE_NAME/          # Main package"
echo ""
echo "Next steps:"
echo "  1. Activate your environment: conda activate $CONDA_ENV_NAME"
echo "  2. Customize your README.md with project details"
echo "  3. Start coding in $MODULE_NAME/"
echo "  4. Write tests in tests/"
echo ""
echo "Development commands:"
echo "  pytest                    # Run tests"
echo "  black .                   # Format code"
echo "  ruff check .              # Lint code"
echo "  mypy $MODULE_NAME         # Type check"
echo "  python -m $MODULE_NAME.main  # Run your module"
