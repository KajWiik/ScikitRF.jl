# ScikitRF.jl

Julia wrapper for the [scikit-rf](https://scikit-rf.org/) Python library.

## Installation

### 1. Install scikit-rf in Python

First, ensure you have scikit-rf installed in your Python environment:

```bash
pip install scikit-rf
```

### 2. Install ScikitRF.jl

```julia
using Pkg
Pkg.add(url="https://github.com/KajWiik/ScikitRF.jl")
```

### 3. Configure Python Path (Optional)

By default, ScikitRF.jl will use the Python at `~/.local/openEMS/venv/bin/python`. If your Python is located elsewhere, set the `JULIA_PYTHONCALL_EXE` environment variable.

Add this to your `~/.julia/config/startup.jl`:

```julia
ENV["JULIA_PYTHONCALL_EXE"] = "/path/to/your/python"
```

Or set it before using the package:

```julia
ENV["JULIA_PYTHONCALL_EXE"] = "/path/to/your/python"
using ScikitRF
```

## Usage

```julia
using ScikitRF

# Create a network
net = Network(name="my_network")
```

## Requirements

- Julia ≥ 1.6
- Python with scikit-rf installed
