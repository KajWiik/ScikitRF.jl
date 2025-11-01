WARNING: this is vibe-coded package and not yet tested, beware!

# ScikitRF.jl

A comprehensive Julia wrapper for the [scikit-rf](https://github.com/scikit-rf/scikit-rf) Python library, providing full access to RF and microwave network analysis tools.

## Overview

ScikitRF.jl brings the powerful capabilities of scikit-rf to Julia using [PythonCall.jl](https://github.com/JuliaPy/PythonCall.jl). This package provides a complete wrapper exposing all public methods and classes from scikit-rf, enabling RF engineers and researchers to perform network analysis, calibration, de-embedding, and much more directly from Julia.

## Features

- **Network Analysis**: Load, manipulate, and analyze n-port networks with S, Y, Z, T, H, G, and ABCD parameters
- **Calibration**: Support for SOLT, TRL, LRM, LRRM, multiline TRL, and other VNA calibration algorithms
- **De-embedding**: IEEE P370 and other de-embedding techniques
- **Media Models**: Transmission line models including freespace, rectangular waveguide, coplanar waveguide, and more
- **File I/O**: Read and write Touchstone (.sNp), CITI, and MDIF files
- **Visualization**: Plotting capabilities (Smith charts, rectangular plots, etc.) when matplotlib is available
- **Circuit Analysis**: Cascade, connect, and analyze complex RF circuits
- **Full API Access**: All public scikit-rf functions and classes are exposed

## Installation

### Prerequisites

1. Julia 1.6 or later
2. Python with scikit-rf installed

### Install scikit-rf

First, ensure scikit-rf is installed in your Python environment:

```bash
pip install scikit-rf
```

Or with conda:

```bash
conda install -c conda-forge scikit-rf
```

### Install ScikitRF.jl

In Julia, add the package:

```julia
using Pkg
Pkg.add("ScikitRF")
```

Or from the Julia REPL package mode (press `]`):

```
pkg> add ScikitRF
```

## Quick Start

```julia
using ScikitRF

# Create a frequency object
freq = Frequency(1, 10, 101, "GHz")

# Create a network from a Touchstone file
nw = Network("mydevice.s2p")

# Access S-parameters
s_params = nw.s          # Complex S-parameters
s_db = nw.s_db          # S-parameters in dB
s_deg = nw.s_deg        # Phase in degrees

# Convert to other parameter representations
y_params = nw.y         # Y-parameters
z_params = nw.z         # Z-parameters
t_params = nw.t         # T-parameters (cascade/ABCD)

# Access frequency information
frequencies = nw.f      # Frequency points in Hz
freq_obj = nw.frequency # Frequency object

# Network operations
nw_db = nw.s_db         # Get S-parameters in dB
nw_flip = flip(nw)      # Flip port order (2-port)
nw_renorm = nw.renormalize(75)  # Renormalize to 75 ohms
```

## Usage Examples

### Loading and Analyzing Networks

```julia
using ScikitRF

# Load a 2-port network from a Touchstone file
nw = Network("filter.s2p")

# Print basic information
println("Number of ports: ", nw.number_of_ports)
println("Frequency range: ", nw.f[1], " - ", nw.f[end], " Hz")

# Access specific S-parameters
s11 = nw.s[:, 1, 1]     # S11 across all frequencies (Julia 1-based indexing)
s21 = nw.s[:, 2, 1]     # S21 across all frequencies

# Get magnitude and phase
s21_db = nw.s_db[:, 2, 1]   # S21 in dB
s21_deg = nw.s_deg[:, 2, 1] # S21 phase in degrees
```

### Creating Networks Programmatically

```julia
using ScikitRF

# Create a frequency sweep
freq = Frequency(1, 10, 101, "GHz")

# Create an ideal transmission line
from skrf.media import DistributedCircuit
tline = DistributedCircuit(frequency=freq, z0=50, gamma=0.1+0.01im)
nw = tline.line(1.0, "m", z0=50)
```

### Network Operations

```julia
using ScikitRF

# Load two networks
nw1 = Network("device1.s2p")
nw2 = Network("device2.s2p")

# Cascade networks (connect output of nw1 to input of nw2)
cascaded = cascade(nw1, nw2)

# Connect specific ports (1-based indexing)
connected = connect(nw1, 2, nw2, 1)  # Connect port 2 of nw1 to port 1 of nw2

# Average multiple measurements
measurements = [Network("meas1.s2p"), Network("meas2.s2p"), Network("meas3.s2p")]
averaged = average(measurements)

# Stitch networks in frequency
low_freq = Network("lowband.s2p")
high_freq = Network("highband.s2p")
stitched = stitch(low_freq, high_freq)
```

### Calibration

```julia
using ScikitRF

# Load measured standards
short_m = Network("short_measured.s1p")
open_m = Network("open_measured.s1p")
load_m = Network("load_measured.s1p")
thru_m = Network("thru_measured.s2p")

# Load ideal standards
short_i = Network("short_ideal.s1p")
open_i = Network("open_ideal.s1p")
load_i = Network("load_ideal.s1p")
thru_i = Network("thru_ideal.s2p")

# Create SOLT calibration
cal = SOLT(
    ideals=[short_i, open_i, load_i, thru_i],
    measured=[short_m, open_m, load_m, thru_m]
)

# Apply calibration to a measurement
dut_measured = Network("dut_measured.s2p")
dut_corrected = cal.apply_cal(dut_measured)

# Save corrected data
dut_corrected.write_touchstone("dut_corrected.s2p")
```

### Working with Media

```julia
using ScikitRF

# Create a frequency object
freq = Frequency(75, 110, 101, "GHz")

# Create a rectangular waveguide
wg = RectangularWaveguide(frequency=freq, a=0.1*inch, b=0.05*inch)

# Generate various transmission line networks
line = wg.line(1.0, "cm", z0=50)          # 1 cm line
delay_short = wg.delay_short(30, "deg")   # Short with delay
match = wg.match()                         # Matched load

# Freespace
fs = Freespace(frequency=freq)
fs_line = fs.line(10, "cm")
```

### De-embedding

```julia
using ScikitRF

# Load networks
dut = Network("dut.s2p")
left_fix = Network("left_fixture.s2p")
right_fix = Network("right_fixture.s2p")

# IEEE P370 2x-Thru de-embedding
deembed = IEEEP370_SE_NZC_2xThru(
    dummy_2xthru=Network("2xthru.s2p"),
    name="deembed"
)
dut_deembedded = deembed.deembed(dut)
```

### Parameter Conversions

```julia
using ScikitRF

nw = Network("device.s2p")

# Get different parameter representations
s_params = nw.s     # S-parameters
y_params = nw.y     # Y-parameters (admittance)
z_params = nw.z     # Z-parameters (impedance)
t_params = nw.t     # T-parameters (cascade/ABCD)
h_params = nw.h     # H-parameters (hybrid)

# Direct conversion functions
z0 = 50
y_from_s = s2y(s_params, z0)
z_from_y = y2z(y_params)
s_from_z = z2s(z_params, z0)
```

### Plotting (requires matplotlib)

```julia
using ScikitRF

nw = Network("amplifier.s2p")

# Various plot types
nw.plot_s_db()              # S-parameters in dB
nw.plot_s_smith()           # Smith chart
nw.plot_s_deg()             # Phase in degrees
nw.plot_s_polar()           # Polar plot

# Time domain
nw.plot_s_time_db()         # Time domain response
nw.plot_s_time_step()       # Step response
```

## Important: Index Conversion (1-based vs 0-based)

Julia uses 1-based indexing while Python uses 0-based indexing. When working with arrays returned from scikit-rf:

- **Array indexing in Julia**: Use standard Julia 1-based indexing when accessing arrays
  ```julia
  nw = Network("device.s2p")
  s11 = nw.s[:, 1, 1]  # First port (Julia index 1 = Python index 0)
  s21 = nw.s[:, 2, 1]  # Port 2 to Port 1
  ```

- **Port numbers in function calls**: When calling functions that require port indices (like `connect`, `subnetwork`), use 1-based indexing:
  ```julia
  # Connect port 2 of nw1 to port 1 of nw2
  result = connect(nw1, 2, nw2, 1)
  
  # Extract ports 1 and 3
  subnet = subnetwork(nw, [1, 3])
  ```

The PythonCall.jl package handles array indexing conversions automatically for most operations. However, be aware of this difference when working with port numbers and array indices explicitly.

## Accessing Additional Features

For features not directly wrapped or for advanced usage, you can access the underlying scikit-rf module:

```julia
using ScikitRF

# Access the skrf module directly
skrf.some_function()

# Or use PythonCall directly
using PythonCall
skrf = pyimport("skrf")
```

## Documentation

- **scikit-rf documentation**: https://scikit-rf.readthedocs.io/
- **scikit-rf examples**: https://scikit-rf.readthedocs.io/en/latest/examples/index.html
- **PythonCall.jl documentation**: https://cjdoris.github.io/PythonCall.jl/stable/

## Requirements

- Julia 1.6+
- PythonCall.jl
- Python 3.7+
- scikit-rf (Python package)

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## License

This package follows the same license as scikit-rf. See the scikit-rf repository for details.

## Acknowledgments

This package wraps the excellent [scikit-rf](https://github.com/scikit-rf/scikit-rf) library. All credit for the underlying functionality goes to the scikit-rf developers and contributors.

## See Also

- [scikit-rf GitHub](https://github.com/scikit-rf/scikit-rf)
- [PythonCall.jl](https://github.com/JuliaPy/PythonCall.jl)
- [RF and Microwave Engineering Resources](https://scikit-rf.readthedocs.io/en/latest/reference/index.html)
