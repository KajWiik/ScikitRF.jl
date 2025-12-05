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

### Basic Usage

```julia
using ScikitRF

# Create a network using the Julia wrapper
net = Network(name="my_network")

# Access Python class methods directly via skrf module
freq = skrf.Frequency.from_f([1e9, 2e9, 3e9])  # Create frequency from array

# You can also use the Frequency wrapper for instances
freq2 = Frequency(start=1, stop=10, npoints=101, unit="GHz")
```

### Accessing Class Methods

Some scikit-rf classes have class methods (like `Frequency.from_f`). To use these, access them through the exported `skrf` module:

```julia
# ✓ Correct - use skrf.ClassName.class_method
freq = skrf.Frequency.from_f([1e9, 2e9, 3e9])

# ✗ Won't work - Frequency is a Julia wrapper, not the Python class
# freq = Frequency.from_f([1e9, 2e9, 3e9])  
```

### Full scikit-rf Access

The `skrf` module gives you access to all scikit-rf functionality:

```julia
# Access any scikit-rf class or function
media = skrf.Media()
cal = skrf.Calibration()

# Use scikit-rf functions
result = skrf.network.connect(net1, 0, net2, 0)
```

## Requirements

- Julia ≥ 1.6
- Python with scikit-rf installed
