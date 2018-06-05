__precompile__()
module SimradEK60TestData

export EK60_SAMPLE

const EK60_SAMPLE = joinpath(dirname(@__FILE__),
                       "../data/JR230-D20091215-T121917.raw")

end # module
