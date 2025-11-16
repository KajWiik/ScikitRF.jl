module ScikitRF

using Reexport

@reexport using PythonCall

const skrf = PythonCall.pynew()

function __init__()
    PythonCall.pycopy!(skrf, pyimport("skrf"))
end

export skrf

greet() = print("Hello World!")

end # module ScikitRF
