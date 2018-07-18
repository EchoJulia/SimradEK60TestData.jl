#!/usr/bin/env julia

using SimradEK60TestData

@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

@test isfile(EK60_SAMPLE)
@test isfile(ECS_SAMPLE)
@test isfile(joinpath(EK60_DATA, "JR230.ecs"))
