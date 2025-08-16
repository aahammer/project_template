# {{PROJECT_NAME}}

A Python project generated from template.

## 📦 Installation

This project uses conda for environment management and poetry for dependency management.

### Setup

1. Clone this repository
2. Run the setup script:
   ```bash
   ./setup.sh [project_name] [python_version]
   ```
   - `project_name`: Optional, defaults to folder name
   - `python_version`: Optional, defaults to 3.11

### Development Setup

```bash
# Activate the conda environment
conda activate {{PROJECT_NAME}}

# Install development dependencies
poetry install
```

## 🚀 Usage

```python
from {{MODULE_NAME}}.main import hello

print(hello())
```

## 🧪 Testing

Run tests with pytest:

```bash
pytest
```

Run tests with coverage:

```bash
pytest --cov={{MODULE_NAME}}
```

## 🔧 Development

### Code Formatting

```bash
# Format code with black
black .

# Lint with ruff
ruff check .

# Type checking with mypy
mypy {{MODULE_NAME}}
```

## 📁 Project Structure

```
{{PROJECT_NAME}}/
├── {{MODULE_NAME}}/          # Main package
│   ├── __init__.py
│   └── main.py
├── tests/                   # Test files
│   ├── __init__.py
│   └── test_main.py
├── docs/                    # Documentation
├── environment.yml          # Conda environment
├── pyproject.toml          # Poetry configuration
└── README.md               # This file
```

## 📄 License

This project is licensed under the [MIT License](LICENSE.md).




