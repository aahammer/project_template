#!/bin/bash
set -euo pipefail

# Python Project Template Setup Script
# Usage:
#   ./setup.sh                # name = folder, python = 3.11
#   ./setup.sh myproj 3.12    # positional
#   ./setup.sh --python 3.12  # flags
#   ./setup.sh -n myproj -p 3.10
#   ./setup.sh myproj --python 3.12

show_help() {
  cat <<'USAGE'
Usage: setup.sh [options] [project_name] [python_version]

Options:
  -n, --name <name>       Project name (overrides positional)
  -p, --python <version>  Python version (overrides positional)
  -h, --help              Show this help

Examples:
  ./setup.sh
  ./setup.sh myproj 3.12
  ./setup.sh --python 3.12
  ./setup.sh --name myproj --python 3.10
USAGE
}

# --- Parse args (flags + positionals) ---
PROJECT_NAME_FLAG=""
PYTHON_VERSION_FLAG=""
POSITIONALS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--name)
      [[ $# -ge 2 ]] || { echo "Error: $1 requires a value"; exit 1; }
      PROJECT_NAME_FLAG="$2"; shift 2;;
    -p|--python)
      [[ $# -ge 2 ]] || { echo "Error: $1 requires a value"; exit 1; }
      PYTHON_VERSION_FLAG="$2"; shift 2;;
    -h|--help) show_help; exit 0;;
    --) shift; break;;
    -*) echo "Error: unknown option '$1'"; exit 1;;
    *) POSITIONALS+=("$1"); shift;;
  esac
done
# Append any args after lone "--"
while [[ $# -gt 0 ]]; do POSITIONALS+=("$1"); shift; done

# Defaults
DEFAULT_NAME="$(basename "$PWD")"
DEFAULT_PY="3.11"

# Resolve final values (flag > positional > default)
PROJECT_NAME="${PROJECT_NAME_FLAG:-${POSITIONALS[0]:-$DEFAULT_NAME}}"
PYTHON_VERSION="${PYTHON_VERSION_FLAG:-${POSITIONALS[1]:-$DEFAULT_PY}}"

# --- Derived ---
PROJECT_DIR="$PWD"
CONDA_ENV_NAME="$PROJECT_NAME"
MODULE_NAME=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr '-' '_')

echo "Setting up Python project: $PROJECT_NAME"
echo "Project directory: $PROJECT_DIR"
echo "Python version: $PYTHON_VERSION"
echo "Conda environment: $CONDA_ENV_NAME"
echo "Module name: $MODULE_NAME"
echo ""

echo "Updating template files with project information..."
# environment.yml
sed -i.bak "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" environment.yml
sed -i.bak "s/{{PYTHON_VERSION}}/$PYTHON_VERSION/g" environment.yml
rm -f environment.yml.bak

# pyproject.toml
sed -i.bak "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" pyproject.toml
sed -i.bak "s/{{MODULE_NAME}}/$MODULE_NAME/g" pyproject.toml
sed -i.bak "s/{{PYTHON_VERSION}}/$PYTHON_VERSION/g" pyproject.toml
rm -f pyproject.toml.bak

# README.md
sed -i.bak "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" README.md
sed -i.bak "s/{{MODULE_NAME}}/$MODULE_NAME/g" README.md
rm -f README.md.bak

echo "Creating project structure..."
mkdir -p "$MODULE_NAME"

cat > "$MODULE_NAME/__init__.py" << EOF
"""$PROJECT_NAME package."""

__version__ = "0.1.0"
EOF

cat > "$MODULE_NAME/main.py" << EOF
"""Main module for $PROJECT_NAME."""

def hello() -> str:
    """Return a hello message."""
    return "Hello from $PROJECT_NAME!"

if __name__ == "__main__":
    print(hello())
EOF

mkdir -p tests
cat > "tests/test_main.py" << EOF
"""Tests for $MODULE_NAME.main module."""

import pytest
from $MODULE_NAME.main import hello

def test_hello():
    result = hello()
    assert isinstance(result, str)
    assert "$PROJECT_NAME" in result
EOF
touch "tests/__init__.py"

if ! command -v conda &> /dev/null; then
  echo "Error: conda is not installed or not in PATH"
  exit 1
fi

if ! conda env list | grep -qE "^\s*$CONDA_ENV_NAME\s"; then
  echo "Creating conda environment from environment.yml..."
  conda env create -f environment.yml
  echo "✅ Conda environment created successfully"
else
  echo "✅ Conda environment '$CONDA_ENV_NAME' already exists"
fi

echo "Activating conda environment: $CONDA_ENV_NAME"
eval "$(conda shell.bash hook)"
conda activate "$CONDA_ENV_NAME"

if ! command -v poetry &> /dev/null; then
  echo "Installing poetry in conda environment..."
  conda install -c conda-forge poetry -y
fi

echo "Installing Python dependencies with Poetry..."
poetry install

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
echo "  1. conda activate $CONDA_ENV_NAME"
echo "  2. Edit README.md"
echo "  3. Start coding in $MODULE_NAME/"
echo "  4. Write tests in tests/"
echo ""
echo "Dev commands: pytest | black . | ruff check . | mypy $MODULE_NAME | python -m $MODULE_NAME.main"
