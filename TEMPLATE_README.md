# Python Project Template

A Python project template with conda environment management and poetry for dependencies.

## Quick Start

### Prerequisites

- **conda** (miniconda or anaconda) must be installed and available in your PATH
- If you don't have conda installed, download it from [miniconda.org](https://docs.conda.io/en/latest/miniconda.html)

### Setup Your New Project

1. **Clone or download this template** to your desired location
2. **Navigate to the project directory**
3. **Run the setup script** with one of these options:

   ```bash
   # Use defaults (folder name as project name + Python 3.11)
   ./setup.sh
   
   # Specify custom project name (uses Python 3.11)
   ./setup.sh my_awesome_project
   
   # Specify both project name and Python version
   ./setup.sh my_awesome_project 3.12
   ./setup.sh data_analysis_tool 3.10
   ./setup.sh web_scraper 3.9
   ```

## What the Setup Script Does

1. **Updates template files** with your project information (pyproject.toml, environment.yml, README.md)
2. **Creates project structure** (package directory, tests, docs)
3. **Creates conda environment** with your specified Python version
4. **Installs poetry** and all development dependencies
5. **Cleans up template files** (removes this file and setup script)
6. **Ready to code!**

## Parameters

### `project_name` (optional)
- **Default**: Current folder name
- **Description**: Name of your project (used for package name, conda environment, etc.)
- **Examples**: `my_project`, `data_analyzer`, `web_scraper`

### `python_version` (optional)
- **Default**: `3.11`
- **Description**: Python version for your project
- **Supported**: `3.8`, `3.9`, `3.10`, `3.11`, `3.12`

## Examples

### Example 1: Machine Learning Project
```bash
./setup.sh ml_classifier 3.11
```
Creates:
- Project name: `ml_classifier`
- Python version: 3.11
- Module name: `ml_classifier`
- Conda environment: `ml_classifier`

### Example 2: Web API
```bash
./setup.sh user_api 3.12
```
Creates:
- Project name: `user_api`
- Python version: 3.12
- Module name: `user_api`
- Conda environment: `user_api`

### Example 3: Data Analysis Tool
```bash
./setup.sh data-analysis-tool 3.10
```
Creates:
- Project name: `data-analysis-tool`
- Python version: 3.10
- Module name: `data_analysis_tool` (hyphens converted to underscores)
- Conda environment: `data-analysis-tool`

## What You Get After Setup

### Project Structure
```
your_project/
├── your_module/              # Main package
│   ├── __init__.py
│   └── main.py
├── tests/                    # Test files
│   ├── __init__.py
│   └── test_main.py
├── docs/                     # Documentation
├── environment.yml           # Conda environment (configured)
├── pyproject.toml           # Poetry configuration (configured)
├── poetry.toml              # Poetry settings
├── LICENSE.md               # MIT License
└── README.md                # Your project's README (ready to customize)
```

### Development Tools Included
- **pytest** - Testing framework
- **pytest-cov** - Coverage reporting
- **black** - Code formatter
- **ruff** - Fast linter
- **mypy** - Type checker

### After Setup Commands
```bash
# Activate your environment
conda activate your_project

# Run tests
pytest

# Format code
black .

# Lint code
ruff check .

# Type check
mypy your_module

# Run your module
python -m your_module.main
```

## Next Steps After Setup

1. **Customize your README.md** with your project's actual description
2. **Update the license** if needed
3. **Add your project dependencies** to `pyproject.toml`
4. **Start coding** in your module directory
5. **Write tests** in the tests directory
6. **Document your API** in the docs directory

## Troubleshooting

### "conda: command not found"
- Install conda from [miniconda.org](https://docs.conda.io/en/latest/miniconda.html)
- Restart your terminal after installation

### "Environment already exists"
- The script will use the existing environment
- To recreate: `conda env remove -n your_project_name` then run setup again

### Permission denied on ./setup.sh
```bash
chmod +x setup.sh
./setup.sh
```

## Template Features

- **Conda + Poetry**: Best of both worlds for environment and dependency management
- **Pre-configured tools**: Testing, linting, formatting, type checking
- **Clean structure**: Follows Python packaging best practices
- **Extensible**: Easy to add more dependencies and tools
- **Cross-platform**: Works on macOS, Linux, and Windows (with conda)

---

**Note**: This file (`TEMPLATE_README.md`) and `setup.sh` will be automatically removed after successful setup to keep your project clean.
