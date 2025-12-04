module ScikitRF

using Reexport

@reexport using PythonCall

macro pywrapper(typename, pytype)
    quote
        struct $(esc(typename))
            py::Py
        end
        
        Base.getproperty(x::$(esc(typename)), name::Symbol) = 
            name === :py ? getfield(x, :py) : getproperty(getfield(x, :py), name)
        
        Base.convert(::Type{Py}, x::$(esc(typename))) = getfield(x, :py)
        Base.convert(::Type{$(esc(typename))}, x::Py) = $(esc(typename))(x)
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

end # module ScikitRF
