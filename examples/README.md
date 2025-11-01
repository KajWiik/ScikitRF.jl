# ScikitRF.jl Examples

This directory contains example scripts demonstrating the usage of ScikitRF.jl.

## Running Examples

To run any example, first ensure you're in the package directory and have activated the project:

```bash
cd /path/to/ScikitRF.jl
julia --project=.
```

Then from the Julia REPL:

```julia
include("examples/basic_usage.jl")
```

Or directly from the command line:

```bash
julia --project=. examples/basic_usage.jl
```

## Available Examples

### basic_usage.jl

Demonstrates:
- Creating frequency objects
- Creating networks
- Using conversion functions (magnitude to dB, etc.)
- Working with physical constants
- Creating media objects
- Impedance and reflection coefficient conversions
- VSWR calculations

## Notes

- These examples use the scikit-rf library through PythonCall.jl
- The first time you run examples, scikit-rf will be automatically installed via CondaPkg
- Some return values from Python functions are numpy arrays and should be used as-is or converted appropriately
- For more complex examples, refer to the scikit-rf documentation: https://scikit-rf.readthedocs.io/
