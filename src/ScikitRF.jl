"""
    ScikitRF

A Julia wrapper for the scikit-rf Python library using PythonCall.jl.

This package provides full access to scikit-rf's RF and microwave engineering
capabilities, including network analysis, calibration, media modeling, and more.

# Important: Index Conversion
Julia uses 1-based indexing while Python uses 0-based indexing. When accessing
array elements or ports, use Julia's 1-based convention - the wrapper handles
conversion automatically where needed. See the documentation for details.

# Installation
The Python package scikit-rf must be installed:
```
pip install scikit-rf
```

# Example Usage
```julia
using ScikitRF

# Create a network from a Touchstone file
nw = Network("myfile.s2p")

# Access properties
freq = nw.frequency
s_params = nw.s

# Convert to other parameters
y_params = nw.y
z_params = nw.z

# Plot (if matplotlib is available)
nw.plot_s_db()
```

For more information, see: https://github.com/scikit-rf/scikit-rf
"""
module ScikitRF

using PythonCall
using PythonCall: pynew, pyimport, pycopy!, pyconvert

# Lazy loading of the skrf Python module
const skrf = pynew()

# ============================================================================
# Core Classes - Direct exports with full wrapper
# ============================================================================

"""
    Network

Wrapper for scikit-rf's Network class representing an n-port microwave network.

The Network class is the primary data structure in scikit-rf, used to store
and manipulate S-parameters and other network parameters.

# Note on Indexing
When accessing specific S-parameters or ports using integer indices in Julia code,
use 1-based indexing (Julia convention). The wrapper handles conversion to Python's
0-based indexing internally.

# Constructor
```julia
nw = Network("filename.s2p")  # Load from Touchstone file
nw = Network()                 # Create empty network
```

# Common Properties
- `s`: S-parameters as complex array
- `frequency`: Frequency object
- `z0`: Port impedances
- `f`: Frequency values in Hz

# Common Methods
- `s_db`: S-parameters in dB
- `s_deg`: S-parameters phase in degrees
- `y`: Y-parameters
- `z`: Z-parameters
- `plot_s_db()`: Plot S-parameters in dB
- `plot_s_smith()`: Plot on Smith chart

See scikit-rf documentation for complete API: https://scikit-rf.readthedocs.io/
"""
const Network = pynew()

"""
    Frequency

Wrapper for scikit-rf's Frequency class representing a frequency sweep.

# Constructor
```julia
freq = Frequency(start=1, stop=10, npoints=101, unit="GHz")
```

# Properties
- `f`: Frequency values in Hz
- `start`: Starting frequency
- `stop`: Stopping frequency
- `npoints`: Number of frequency points
- `unit`: Frequency unit
"""
const Frequency = pynew()

"""
    NetworkSet

Wrapper for scikit-rf's NetworkSet class for handling collections of networks.

A NetworkSet is useful for analyzing statistical properties of multiple networks,
such as measurement repeatability or Monte Carlo simulations.

# Constructor
```julia
ns = NetworkSet([nw1, nw2, nw3])
```
"""
const NetworkSet = pynew()

"""
    Calibration

Base class for VNA calibration algorithms.

Calibration removes systematic errors from VNA measurements using known standards.
"""
const Calibration = pynew()

"""
    SOLT

Short-Open-Load-Thru calibration algorithm.

# Example
```julia
cal = SOLT(ideals=[short, open, load, thru],
           measured=[short_m, open_m, load_m, thru_m])
nw_corrected = cal.apply_cal(nw_measured)
```
"""
const SOLT = pynew()

"""
    TRL

Thru-Reflect-Line calibration algorithm.
"""
const TRL = pynew()

"""
    LRM

Line-Reflect-Match calibration algorithm.
"""
const LRM = pynew()

"""
    LRRM

Line-Reflect-Reflect-Match calibration algorithm.
"""
const LRRM = pynew()

"""
    EightTerm

Eight-term error model calibration.
"""
const EightTerm = pynew()

"""
    MultilineTRL

Multiline TRL calibration algorithm.
"""
const MultilineTRL = pynew()

"""
    NISTMultilineTRL

NIST Multiline TRL calibration algorithm.
"""
const NISTMultilineTRL = pynew()

"""
    TUGMultilineTRL

TUG Multiline TRL calibration algorithm.
"""
const TUGMultilineTRL = pynew()

"""
    CalibrationSet

Container for multiple calibration instances.
"""
const CalibrationSet = pynew()

# Media classes
"""
    Freespace

Freespace transmission line media.

# Example
```julia
freq = Frequency(1, 10, 101, "GHz")
fs = Freespace(frequency=freq)
```
"""
const Freespace = pynew()

"""
    RectangularWaveguide

Rectangular waveguide transmission line media.

# Example
```julia
freq = Frequency(75, 110, 101, "GHz")
wg = RectangularWaveguide(frequency=freq, a=0.1*inch, b=0.05*inch)
```
"""
const RectangularWaveguide = pynew()

"""
    CPW

Coplanar waveguide transmission line media.
"""
const CPW = pynew()

"""
    DistributedCircuit

Distributed circuit transmission line media.
"""
const DistributedCircuit = pynew()

# Deembedding classes
"""
    Deembedding

Base class for de-embedding algorithms.
"""
const Deembedding = pynew()

"""
    IEEEP370

IEEE P370 de-embedding algorithm.
"""
const IEEEP370 = pynew()

"""
    OpenShort

Open-Short de-embedding.
"""
const OpenShort = pynew()

"""
    Open

Open de-embedding.
"""
const Open = pynew()

"""
    Short

Short de-embedding.
"""
const Short = pynew()

"""
    SplitPi

Split-Pi de-embedding.
"""
const SplitPi = pynew()

"""
    SplitTee

Split-Tee de-embedding.
"""
const SplitTee = pynew()

"""
    AdmittanceCancel

Admittance cancellation de-embedding.
"""
const AdmittanceCancel = pynew()

"""
    ImpedanceCancel

Impedance cancellation de-embedding.
"""
const ImpedanceCancel = pynew()

# Circuit and other analysis classes
"""
    Circuit

Circuit representation for cascade and connection analysis.
"""
const Circuit = pynew()

"""
    VectorFitting

Vector fitting for rational function approximation of frequency responses.
"""
const VectorFitting = pynew()

# File format classes
"""
    Touchstone

Touchstone file format reader/writer.
"""
const Touchstone = pynew()

"""
    Citi

CITI file format reader/writer.
"""
const Citi = pynew()

"""
    Mdif

MDIF file format reader/writer.
"""
const Mdif = pynew()

# ============================================================================
# Conversion Functions
# ============================================================================

# S-parameter conversions
"""
    s2z(s, z0)

Convert S-parameters to Z-parameters.
"""
const s2z = pynew()

"""
    s2y(s, z0)

Convert S-parameters to Y-parameters.
"""
const s2y = pynew()

"""
    s2t(s)

Convert S-parameters to T-parameters (cascade/ABCD).
"""
const s2t = pynew()

"""
    s2h(s, z0)

Convert S-parameters to H-parameters (hybrid).
"""
const s2h = pynew()

"""
    s2g(s, z0)

Convert S-parameters to G-parameters (inverse hybrid).
"""
const s2g = pynew()

"""
    s2a(s, z0)

Convert S-parameters to A-parameters (power waves).
"""
const s2a = pynew()

"""
    z2s(z, z0)

Convert Z-parameters to S-parameters.
"""
const z2s = pynew()

"""
    z2y(z)

Convert Z-parameters to Y-parameters.
"""
const z2y = pynew()

"""
    z2t(z)

Convert Z-parameters to T-parameters.
"""
const z2t = pynew()

"""
    z2h(z)

Convert Z-parameters to H-parameters.
"""
const z2h = pynew()

"""
    z2a(z, z0)

Convert Z-parameters to A-parameters.
"""
const z2a = pynew()

"""
    y2s(y, z0)

Convert Y-parameters to S-parameters.
"""
const y2s = pynew()

"""
    y2z(y)

Convert Y-parameters to Z-parameters.
"""
const y2z = pynew()

"""
    y2t(y)

Convert Y-parameters to T-parameters.
"""
const y2t = pynew()

"""
    t2s(t)

Convert T-parameters to S-parameters.
"""
const t2s = pynew()

"""
    t2z(t)

Convert T-parameters to Z-parameters.
"""
const t2z = pynew()

"""
    t2y(t)

Convert T-parameters to Y-parameters.
"""
const t2y = pynew()

"""
    h2s(h, z0)

Convert H-parameters to S-parameters.
"""
const h2s = pynew()

"""
    h2z(h)

Convert H-parameters to Z-parameters.
"""
const h2z = pynew()

"""
    g2s(g, z0)

Convert G-parameters to S-parameters.
"""
const g2s = pynew()

"""
    a2s(a, z0)

Convert A-parameters to S-parameters.
"""
const a2s = pynew()

"""
    a2z(a, z0)

Convert A-parameters to Z-parameters.
"""
const a2z = pynew()

# ============================================================================
# Network Operations
# ============================================================================

"""
    connect(ntwkA, portA, ntwkB, portB)

Connect two networks together at specified ports.

# Note on Port Indexing
Use 1-based port indices (Julia convention). For example, to connect port 1 of
network A to port 2 of network B:
```julia
result = connect(ntwkA, 1, ntwkB, 2)
```
"""
const connect = pynew()

"""
    cascade(ntwkA, ntwkB)

Cascade two 2-port networks.
"""
const cascade = pynew()

"""
    cascade_list(ntwk_list)

Cascade a list of 2-port networks.
"""
const cascade_list = pynew()

"""
    innerconnect(ntwk, port1, port2)

Connect two ports of a network together.

# Note on Port Indexing
Use 1-based port indices (Julia convention).
"""
const innerconnect = pynew()

"""
    concat_ports(ntwk_list)

Concatenate networks along port axis.
"""
const concat_ports = pynew()

"""
    de_embed(ntwk)

De-embed a network.
"""
const de_embed = pynew()

"""
    flip(ntwk)

Flip port ordering of a 2-port network.
"""
const flip = pynew()

"""
    terminate(ntwk, terminations)

Terminate network ports with given loads.
"""
const terminate = pynew()

"""
    average(ntwk_list)

Average a list of networks.
"""
const average = pynew()

"""
    overlap(ntwk1, ntwk2)

Return overlapping frequency range of two networks.
"""
const overlap = pynew()

"""
    stitch(ntwk1, ntwk2)

Stitch two networks together in frequency.
"""
const stitch = pynew()

"""
    renormalize_s(s, z0_old, z0_new)

Renormalize S-parameters to new characteristic impedance.
"""
const renormalize_s = pynew()

"""
    subnetwork(ntwk, ports)

Extract a subnetwork with specified ports.

# Note on Port Indexing
Use 1-based port indices (Julia convention) in the ports list.
"""
const subnetwork = pynew()

# ============================================================================
# File I/O Functions
# ============================================================================

"""
    load_all_touchstones(dir)

Load all Touchstone files from a directory.
"""
const load_all_touchstones = pynew()

"""
    read_all_networks(dir)

Read all network files from a directory.
"""
const read_all_networks = pynew()

"""
    write_dict_of_networks(dict, dir)

Write a dictionary of networks to files.
"""
const write_dict_of_networks = pynew()

"""
    network_2_spreadsheet(ntwk, filename)

Write network data to a spreadsheet.
"""
const network_2_spreadsheet = pynew()

"""
    networkset_2_spreadsheet(ns, filename)

Write network set data to a spreadsheet.
"""
const networkset_2_spreadsheet = pynew()

"""
    network_2_dataframe(ntwk)

Convert network to pandas DataFrame.
"""
const network_2_dataframe = pynew()

# ============================================================================
# Plotting Functions (require matplotlib)
# ============================================================================

"""
    setup_pylab()

Setup pylab for plotting.
"""
const setup_pylab = pynew()

"""
    stylely(rc_dict)

Apply plotting style.
"""
const stylely = pynew()

# ============================================================================
# Utility Functions
# ============================================================================

"""
    complex_2_db(z)

Convert complex values to dB magnitude.
"""
const complex_2_db = pynew()

"""
    complex_2_magnitude(z)

Convert complex values to magnitude.
"""
const complex_2_magnitude = pynew()

"""
    complex_2_degree(z)

Convert complex values to phase in degrees.
"""
const complex_2_degree = pynew()

"""
    complex_2_radian(z)

Convert complex values to phase in radians.
"""
const complex_2_radian = pynew()

"""
    mag_2_db(mag)

Convert magnitude to dB.
"""
const mag_2_db = pynew()

"""
    db_2_mag(db)

Convert dB to magnitude.
"""
const db_2_mag = pynew()

"""
    degree_2_radian(deg)

Convert degrees to radians.
"""
const degree_2_radian = pynew()

"""
    radian_2_degree(rad)

Convert radians to degrees.
"""
const radian_2_degree = pynew()

"""
    electrical_length(gamma, f, d, deg=false)

Calculate electrical length.
"""
const electrical_length = pynew()

"""
    distance_2_electrical_length(d, deg=false)

Convert physical distance to electrical length.
"""
const distance_2_electrical_length = pynew()

"""
    electrical_length_2_distance(theta, deg=true)

Convert electrical length to physical distance.
"""
const electrical_length_2_distance = pynew()

"""
    skin_depth(f, rho, mu_r=1)

Calculate skin depth.
"""
const skin_depth = pynew()

"""
    impedance_mismatch(z1, z2)

Calculate reflection coefficient from impedance mismatch.
"""
const impedance_mismatch = pynew()

# Reflection coefficient and impedance conversions
"""
    zl_2_Gamma0(zl, z0)

Convert load impedance to reflection coefficient.
"""
const zl_2_Gamma0 = pynew()

"""
    Gamma0_2_zl(Gamma0, z0)

Convert reflection coefficient to load impedance.
"""
const Gamma0_2_zl = pynew()

"""
    zl_2_zin(zl, theta)

Convert load impedance to input impedance.
"""
const zl_2_zin = pynew()

"""
    zl_2_Gamma_in(zl, theta, z0)

Convert load impedance to input reflection coefficient.
"""
const zl_2_Gamma_in = pynew()

"""
    Gamma0_2_zin(Gamma0, z0, theta)

Convert reflection coefficient to input impedance.
"""
const Gamma0_2_zin = pynew()

"""
    Gamma0_2_Gamma_in(Gamma0, theta)

Convert reflection coefficient to input reflection coefficient.
"""
const Gamma0_2_Gamma_in = pynew()

# VSWR and return loss
"""
    Gamma0_2_swr(Gamma0)

Convert reflection coefficient to VSWR.
"""
const Gamma0_2_swr = pynew()

"""
    zl_2_swr(zl, z0)

Convert load impedance to VSWR.
"""
const zl_2_swr = pynew()

"""
    passivity(ntwk)

Calculate passivity metric for a network.
"""
const passivity = pynew()

"""
    reciprocity(ntwk)

Calculate reciprocity metric for a network.
"""
const reciprocity = pynew()

# Time-domain functions
"""
    time_gate(ntwk, start, stop)

Apply time-domain gating to a network.
"""
const time_gate = pynew()

"""
    psd2TimeDomain(ntwk)

Convert power spectral density to time domain.
"""
const psd2TimeDomain = pynew()

# Smith chart and stability
"""
    smith(ntwk)

Plot network on Smith chart.
"""
const smith = pynew()

# Statistics
"""
    stdev(ntwk_list)

Calculate standard deviation of network list.
"""
const stdev = pynew()

# Noise functions
"""
    noise_2_noise_figure(noise_temp)

Convert noise temperature to noise figure.
"""
const noise_2_noise_figure = pynew()

# Q-factor analysis
"""
    Qfactor

Q-factor analysis class for resonator characterization.
"""
const Qfactor = pynew()

# Multiport calibration
"""
    MultiportCal

Multiport calibration base class.
"""
const MultiportCal = pynew()

"""
    MultiportSOLT

Multiport SOLT calibration.
"""
const MultiportSOLT = pynew()

# IEEEP370 standards
"""
    IEEEP370_SE_ZC_2xThru

IEEE P370 single-ended zero-length 2x-thru method.
"""
const IEEEP370_SE_ZC_2xThru = pynew()

"""
    IEEEP370_SE_NZC_2xThru

IEEE P370 single-ended non-zero-length 2x-thru method.
"""
const IEEEP370_SE_NZC_2xThru = pynew()

"""
    IEEEP370_MM_ZC_2xThru

IEEE P370 mixed-mode zero-length 2x-thru method.
"""
const IEEEP370_MM_ZC_2xThru = pynew()

"""
    IEEEP370_MM_NZC_2xThru

IEEE P370 mixed-mode non-zero-length 2x-thru method.
"""
const IEEEP370_MM_NZC_2xThru = pynew()

# More utility functions
"""
    find_nearest(array, value)

Find nearest value in array.
"""
const find_nearest = pynew()

"""
    find_nearest_index(array, value)

Find index of nearest value in array.

# Note on Index Return
This function returns a Julia 1-based index (converted from Python's 0-based).
"""
const find_nearest_index = pynew()

"""
    now_string()

Get current timestamp as string.
"""
const now_string = pynew()

"""
    save_sesh()

Save current session data.
"""
const save_sesh = pynew()

# Constants
"""
    c

Speed of light in vacuum (m/s).
"""
const c = pynew()

"""
    k_boltzmann (K_BOLTZMANN)

Boltzmann constant (J/K).
"""
const k_boltzmann = pynew()

"""
    mu_0

Permeability of free space (H/m).
"""
const mu_0 = pynew()

"""
    ONE

Complex number 1+0j.
"""
const ONE = pynew()

"""
    ZERO

Complex number 0+0j.
"""
const ZERO = pynew()

"""
    inch

Inch to meter conversion factor.
"""
const inch = pynew()

"""
    mil

Mil to meter conversion factor (1 mil = 0.001 inch).
"""
const mil = pynew()

"""
    feet_2_meter(feet)

Convert feet to meters.
"""
const feet_2_meter = pynew()

"""
    meter_2_feet(meter)

Convert meters to feet.
"""
const meter_2_feet = pynew()

# Two-port functions
"""
    two_port_reflect(ntwk, Gamma0)

Two-port reflection analysis.
"""
const two_port_reflect = pynew()

"""
    chopinhalf(ntwk)

Split a 2N-port into two N-ports.
"""
const chopinhalf = pynew()

# ============================================================================
# Initialize all Python objects
# ============================================================================

function __init__()
    pycopy!(skrf, pyimport("skrf"))
    
    # Initialize main classes
    pycopy!(Network, skrf.Network)
    pycopy!(Frequency, skrf.Frequency)
    pycopy!(NetworkSet, skrf.NetworkSet)
    
    # Initialize calibration classes
    pycopy!(Calibration, skrf.Calibration)
    pycopy!(SOLT, skrf.SOLT)
    pycopy!(TRL, skrf.TRL)
    pycopy!(LRM, skrf.LRM)
    pycopy!(LRRM, skrf.LRRM)
    pycopy!(EightTerm, skrf.EightTerm)
    pycopy!(MultilineTRL, skrf.MultilineTRL)
    pycopy!(NISTMultilineTRL, skrf.NISTMultilineTRL)
    pycopy!(TUGMultilineTRL, skrf.TUGMultilineTRL)
    pycopy!(CalibrationSet, skrf.CalibrationSet)
    
    # Initialize media classes
    pycopy!(Freespace, skrf.Freespace)
    pycopy!(RectangularWaveguide, skrf.RectangularWaveguide)
    
    # Initialize deembedding classes
    pycopy!(Deembedding, skrf.Deembedding)
    pycopy!(IEEEP370, skrf.IEEEP370)
    pycopy!(OpenShort, skrf.OpenShort)
    pycopy!(Open, skrf.Open)
    pycopy!(Short, skrf.Short)
    pycopy!(SplitPi, skrf.SplitPi)
    pycopy!(SplitTee, skrf.SplitTee)
    pycopy!(AdmittanceCancel, skrf.AdmittanceCancel)
    pycopy!(ImpedanceCancel, skrf.ImpedanceCancel)
    
    # Initialize other analysis classes
    pycopy!(Circuit, skrf.Circuit)
    pycopy!(VectorFitting, skrf.VectorFitting)
    pycopy!(Qfactor, skrf.Qfactor)
    
    # Initialize file format classes
    pycopy!(Touchstone, skrf.Touchstone)
    pycopy!(Citi, skrf.Citi)
    pycopy!(Mdif, skrf.Mdif)
    
    # Initialize conversion functions
    pycopy!(s2z, skrf.s2z)
    pycopy!(s2y, skrf.s2y)
    pycopy!(s2t, skrf.s2t)
    pycopy!(s2h, skrf.s2h)
    pycopy!(s2g, skrf.s2g)
    pycopy!(s2a, skrf.s2a)
    pycopy!(z2s, skrf.z2s)
    pycopy!(z2y, skrf.z2y)
    pycopy!(z2t, skrf.z2t)
    pycopy!(z2h, skrf.z2h)
    pycopy!(z2a, skrf.z2a)
    pycopy!(y2s, skrf.y2s)
    pycopy!(y2z, skrf.y2z)
    pycopy!(y2t, skrf.y2t)
    pycopy!(t2s, skrf.t2s)
    pycopy!(t2z, skrf.t2z)
    pycopy!(t2y, skrf.t2y)
    pycopy!(h2s, skrf.h2s)
    pycopy!(h2z, skrf.h2z)
    pycopy!(g2s, skrf.g2s)
    pycopy!(a2s, skrf.a2s)
    pycopy!(a2z, skrf.a2z)
    
    # Initialize network operations
    pycopy!(connect, skrf.connect)
    pycopy!(cascade, skrf.cascade)
    pycopy!(cascade_list, skrf.cascade_list)
    pycopy!(innerconnect, skrf.innerconnect)
    pycopy!(concat_ports, skrf.concat_ports)
    pycopy!(de_embed, skrf.de_embed)
    pycopy!(flip, skrf.flip)
    pycopy!(terminate, skrf.terminate)
    pycopy!(average, skrf.average)
    pycopy!(overlap, skrf.overlap)
    pycopy!(stitch, skrf.stitch)
    pycopy!(renormalize_s, skrf.renormalize_s)
    pycopy!(subnetwork, skrf.subnetwork)
    
    # Initialize file I/O functions
    pycopy!(load_all_touchstones, skrf.load_all_touchstones)
    pycopy!(read_all_networks, skrf.read_all_networks)
    pycopy!(write_dict_of_networks, skrf.write_dict_of_networks)
    pycopy!(network_2_spreadsheet, skrf.network_2_spreadsheet)
    pycopy!(networkset_2_spreadsheet, skrf.networkset_2_spreadsheet)
    pycopy!(network_2_dataframe, skrf.network_2_dataframe)
    
    # Initialize plotting functions (may not work without matplotlib)
    try
        pycopy!(setup_pylab, skrf.setup_pylab)
        pycopy!(stylely, skrf.stylely)
    catch
        # Plotting functions unavailable without matplotlib
    end
    
    # Initialize utility functions
    pycopy!(complex_2_db, skrf.complex_2_db)
    pycopy!(complex_2_magnitude, skrf.complex_2_magnitude)
    pycopy!(complex_2_degree, skrf.complex_2_degree)
    pycopy!(complex_2_radian, skrf.complex_2_radian)
    pycopy!(mag_2_db, skrf.mag_2_db)
    pycopy!(db_2_mag, skrf.db_2_mag)
    pycopy!(degree_2_radian, skrf.degree_2_radian)
    pycopy!(radian_2_degree, skrf.radian_2_degree)
    pycopy!(electrical_length, skrf.electrical_length)
    pycopy!(distance_2_electrical_length, skrf.distance_2_electrical_length)
    pycopy!(electrical_length_2_distance, skrf.electrical_length_2_distance)
    pycopy!(skin_depth, skrf.skin_depth)
    pycopy!(impedance_mismatch, skrf.impedance_mismatch)
    
    # Initialize reflection coefficient conversions
    pycopy!(zl_2_Gamma0, skrf.zl_2_Gamma0)
    pycopy!(Gamma0_2_zl, skrf.Gamma0_2_zl)
    pycopy!(zl_2_zin, skrf.zl_2_zin)
    pycopy!(zl_2_Gamma_in, skrf.zl_2_Gamma_in)
    pycopy!(Gamma0_2_zin, skrf.Gamma0_2_zin)
    pycopy!(Gamma0_2_Gamma_in, skrf.Gamma0_2_Gamma_in)
    pycopy!(Gamma0_2_swr, skrf.Gamma0_2_swr)
    pycopy!(zl_2_swr, skrf.zl_2_swr)
    
    # Initialize network analysis functions
    pycopy!(passivity, skrf.passivity)
    pycopy!(reciprocity, skrf.reciprocity)
    pycopy!(time_gate, skrf.time_gate)
    pycopy!(psd2TimeDomain, skrf.psd2TimeDomain)
    pycopy!(stdev, skrf.stdev)
    
    # Initialize multiport calibration
    pycopy!(MultiportCal, skrf.MultiportCal)
    pycopy!(MultiportSOLT, skrf.MultiportSOLT)
    
    # Initialize IEEE P370 methods
    pycopy!(IEEEP370_SE_ZC_2xThru, skrf.IEEEP370_SE_ZC_2xThru)
    pycopy!(IEEEP370_SE_NZC_2xThru, skrf.IEEEP370_SE_NZC_2xThru)
    pycopy!(IEEEP370_MM_ZC_2xThru, skrf.IEEEP370_MM_ZC_2xThru)
    pycopy!(IEEEP370_MM_NZC_2xThru, skrf.IEEEP370_MM_NZC_2xThru)
    
    # Initialize utility functions
    pycopy!(find_nearest, skrf.find_nearest)
    pycopy!(find_nearest_index, skrf.find_nearest_index)
    pycopy!(now_string, skrf.now_string)
    pycopy!(save_sesh, skrf.save_sesh)
    pycopy!(two_port_reflect, skrf.two_port_reflect)
    pycopy!(chopinhalf, skrf.chopinhalf)
    
    # Initialize constants
    pycopy!(c, skrf.c)
    pycopy!(k_boltzmann, skrf.K_BOLTZMANN)
    pycopy!(mu_0, skrf.mu_0)
    pycopy!(ONE, skrf.ONE)
    pycopy!(ZERO, skrf.ZERO)
    pycopy!(inch, skrf.inch)
    pycopy!(mil, skrf.mil)
    pycopy!(feet_2_meter, skrf.feet_2_meter)
    pycopy!(meter_2_feet, skrf.meter_2_feet)
end

# ============================================================================
# Exports
# ============================================================================

# Export main classes
export Network, Frequency, NetworkSet
export Calibration, SOLT, TRL, LRM, LRRM, EightTerm
export MultilineTRL, NISTMultilineTRL, TUGMultilineTRL, CalibrationSet
export Freespace, RectangularWaveguide
export Deembedding, IEEEP370, OpenShort, Open, Short
export SplitPi, SplitTee, AdmittanceCancel, ImpedanceCancel
export Circuit, VectorFitting, Qfactor
export Touchstone, Citi, Mdif
export MultiportCal, MultiportSOLT
export IEEEP370_SE_ZC_2xThru, IEEEP370_SE_NZC_2xThru
export IEEEP370_MM_ZC_2xThru, IEEEP370_MM_NZC_2xThru

# Export conversion functions
export s2z, s2y, s2t, s2h, s2g, s2a
export z2s, z2y, z2t, z2h, z2a
export y2s, y2z, y2t
export t2s, t2z, t2y
export h2s, h2z
export g2s
export a2s, a2z

# Export network operations
export connect, cascade, cascade_list, innerconnect
export concat_ports, de_embed, flip, terminate
export average, overlap, stitch, renormalize_s, subnetwork

# Export file I/O
export load_all_touchstones, read_all_networks
export write_dict_of_networks, network_2_spreadsheet, networkset_2_spreadsheet
export network_2_dataframe

# Export plotting
export setup_pylab, stylely

# Export utility functions
export complex_2_db, complex_2_magnitude, complex_2_degree, complex_2_radian
export mag_2_db, db_2_mag, degree_2_radian, radian_2_degree
export electrical_length, distance_2_electrical_length, electrical_length_2_distance
export skin_depth, impedance_mismatch
export zl_2_Gamma0, Gamma0_2_zl, zl_2_zin, zl_2_Gamma_in
export Gamma0_2_zin, Gamma0_2_Gamma_in, Gamma0_2_swr, zl_2_swr
export passivity, reciprocity, time_gate, psd2TimeDomain, stdev
export find_nearest, find_nearest_index
export now_string, save_sesh, two_port_reflect, chopinhalf

# Export constants
export c, k_boltzmann, mu_0, ONE, ZERO, inch, mil
export feet_2_meter, meter_2_feet

# Export the skrf module itself for advanced users
export skrf

end # module ScikitRF
