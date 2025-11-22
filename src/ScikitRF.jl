module ScikitRF

using Reexport

@reexport using PythonCall

const skrf = PythonCall.pynew()

function __init__()
    PythonCall.pycopy!(skrf, pyimport("skrf"))
end


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

@pywrapper Network Network

Network() = Network(skrf.Network())

export skrf, ScikitRF, Network


end # module ScikitRF
