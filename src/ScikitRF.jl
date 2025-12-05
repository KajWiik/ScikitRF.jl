module ScikitRF

using Reexport

@reexport using PythonCall

"""
    @skrf_wrapper TypeName

Generate a Julia wrapper struct for a scikit-rf Python class.

Creates a struct with:
- An inner `py::Py` field to hold the Python object
- Constructor from `Py` object
- Constructor that forwards args/kwargs to `skrf.TypeName(...)`
- Property delegation to the Python object
- Type conversions between Julia wrapper and `Py`

# Example
```julia
@skrf_wrapper Network
# Generates wrapper for skrf.Network

# Usage:
net = Network("myfile.s2p")  # Calls skrf.Network("myfile.s2p")
net.frequency                 # Accesses net.py.frequency
```
"""
macro skrf_wrapper(typename)
    pyclass = esc(typename)
    quote
        struct $(pyclass)
            py::Py
            $(pyclass)(py::Py) = new(py)
            function $(pyclass)(args...; kwargs...)
                new(skrf.$(typename)(args...; kwargs...))
            end
        end
        
        Base.getproperty(x::$(pyclass), name::Symbol) = 
            name === :py ? getfield(x, :py) : getproperty(getfield(x, :py), name)
        
        Base.convert(::Type{Py}, x::$(pyclass)) = getfield(x, :py)
        Base.convert(::Type{$(pyclass)}, x::Py) = $(pyclass)(x)
        
        export $(pyclass)
    end
end

# Store the Python module reference
const skrf = PythonCall.pynew()

function __init__()
    # Set default Python path if not already set
    if !haskey(ENV, "JULIA_PYTHONCALL_EXE")
        ENV["JULIA_PYTHONCALL_EXE"] = joinpath(homedir(), ".local", "openEMS", "venv", "bin", "python")
    end
    # Disable CondaPkg
    ENV["JULIA_CONDAPKG_BACKEND"] = "Null"
    
    # Import the scikit-rf module
    PythonCall.pycopy!(skrf, pyimport("skrf"))
end

struct Network
    py::Py
    Network(py::Py) = new(py)
    function Network(args...; kwargs...)
        new(skrf.Network(args...; kwargs...))
    end
end

Base.getproperty(x::Network, name::Symbol) = 
    name === :py ? getfield(x, :py) : getproperty(getfield(x, :py), name)

Base.convert(::Type{Py}, x::Network) = getfield(x, :py)
Base.convert(::Type{Network}, x::Py) = Network(x)

export Network

struct Frequency
    py::Py
    Frequency(py::Py) = new(py)
    function Frequency(args...; kwargs...)
        new(skrf.Frequency(args...; kwargs...))
    end
end

Base.getproperty(x::Frequency, name::Symbol) = 
    name === :py ? getfield(x, :py) : getproperty(getfield(x, :py), name)

Base.convert(::Type{Py}, x::Frequency) = getfield(x, :py)
Base.convert(::Type{Frequency}, x::Py) = Frequency(x)

export Frequency

# Export the skrf module for direct access to Python classes and their class methods
# This allows users to call: skrf.Frequency.from_f(...) for class methods
# while still using the Julia wrappers: Frequency(...) for instances
export skrf

# Test example of the @skrf_wrapper macro (not yet applied to Network/Frequency)
# Uncomment to test:
# @skrf_wrapper Media

end # module ScikitRF

