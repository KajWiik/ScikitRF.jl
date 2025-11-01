"""
Basic usage examples for ScikitRF.jl

This file demonstrates common operations with the ScikitRF.jl package.
"""

using ScikitRF
using PythonCall: pyconvert

println("=== ScikitRF.jl Basic Usage Examples ===\n")

# Example 1: Creating a Frequency object
println("1. Creating a Frequency object:")
freq = Frequency(1, 10, 101, "GHz")
println("   Frequency: ", pyconvert(Float64, freq.start), " to ", pyconvert(Float64, freq.stop), " GHz")
println("   Number of points: ", pyconvert(Int, freq.npoints))
println()

# Example 2: Creating an empty Network
println("2. Creating an empty Network:")
nw = Network()
println("   Empty network created: ", nw)
println()

# Example 3: Using conversion functions
println("3. Using utility conversion functions:")
mag = 2.0
db = mag_2_db(mag)
println("   Magnitude ", mag, " = ", pyconvert(Float64, db), " dB")

db_val = 20.0
mag_back = db_2_mag(db_val)
println("   ", db_val, " dB = magnitude ", pyconvert(Float64, mag_back))
println()

# Example 4: Working with constants
println("4. Physical constants:")
println("   Speed of light: ", pyconvert(Float64, c), " m/s")
println("   1 inch = ", pyconvert(Float64, inch), " m")
println("   1 mil = ", pyconvert(Float64, mil), " m")
println()

# Example 5: Creating a media object
println("5. Creating a Freespace media:")
fs = Freespace(frequency=freq, z0=50)
println("   Freespace media created with z0=50Ω")
println()

# Example 6: Impedance conversions
println("6. Impedance and reflection coefficient conversions:")
zl = 75.0 + 25.0im
z0 = 50.0
gamma = zl_2_Gamma0(zl, z0)
println("   Load impedance: ", zl, " Ω")
println("   Characteristic impedance: ", z0, " Ω")
println("   Reflection coefficient: ", gamma)

zl_back = Gamma0_2_zl(gamma, z0)
println("   Back to impedance: ", zl_back, " Ω")
println()

# Example 7: VSWR calculation
println("7. VSWR calculation:")
vswr = Gamma0_2_swr(gamma)
println("   VSWR: ", vswr)
println()

println("=== Examples completed successfully! ===")
