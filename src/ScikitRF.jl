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

struct ScikitRF
    py::Py
    function ScikitRF()
        new(pyimport("skrf"))
    end
end

Base.getproperty(x::ScikitRF, name::Symbol) = 
    name === :py ? getfield(x, :py) : getproperty(getfield(x, :py), name)

struct Network
    py::Py
    Network(py::Py) = new(py)
    function Network(args...; kwargs...)
        new(pyimport("skrf").Network(args...; kwargs...))
    end
end

Base.getproperty(x::Network, name::Symbol) = 
    name === :py ? getfield(x, :py) : getproperty(getfield(x, :py), name)

Base.convert(::Type{Py}, x::Network) = getfield(x, :py)
Base.convert(::Type{Network}, x::Py) = Network(x)

export ScikitRF, Network


end # module ScikitRF
