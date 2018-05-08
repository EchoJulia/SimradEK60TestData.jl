#!/usr/bin/env julia

# Compare results from SimradEK60.jl to those from Echoview

using Base.Test
using SimradEK60
using CSV
using DataFrames

function rmse(A, B)
    a = A .- B
    a = a.^2
    return sqrt(maximum(a))
end

function compare(A, B)
    x = rmse(A, B)
    info(x)
    x < 1e-4
end


function load_echoview_matrix(filename)
    df = CSV.read(filename,
                  header=false,
                  datarow=2)

    A = transpose(get.(convert(Array,df[:, 14:end])))

    A= Float64.(A)
end

@testset "all" begin

    filename = "JR230-D20091215-T121917.raw"

    ps = collect(pings(filename))
    ps38 = [p for p in ps if p.frequency == 38000]
    ps120 = [p for p in ps if p.frequency == 120000]
    ps200 = [p for p in ps if p.frequency == 200000]

    # N.B. Echoview drops the first sample, so we'll do the same for
    # comparison purposes.

    Sv38 = Sv(ps38)[2:end,:]
    Sv120 = Sv(ps120)[2:end,:]
    Sv200 = Sv(ps200)[2:end,:]

    filename = "JR230-D20091215-T121917-38-uncal.sv.csv"
    A = load_echoview_matrix(filename)

    @test compare(A, Sv38)

    filename = "JR230-D20091215-T121917-120-uncal.sv.csv"
    A = load_echoview_matrix(filename)
    @test compare(A, Sv120)


    filename = "JR230-D20091215-T121917-200-uncal.sv.csv"
    A = load_echoview_matrix(filename)
    @test compare(A, Sv200)

    TS38 = TS(ps38)[2:end,:]
    TS120 = TS(ps120)[2:end,:]
    TS200 = TS(ps200)[2:end,:]

    filename = "JR230-D20091215-T121917-38-uncal.ts.csv"
    A = load_echoview_matrix(filename)
    @test compare(A, TS38)

    filename = "JR230-D20091215-T121917-120-uncal.ts.csv"
    A = load_echoview_matrix(filename)
    @test compare(A, TS120)

    filename = "JR230-D20091215-T121917-200-uncal.ts.csv"
    A = load_echoview_matrix(filename)
    @test compare(A, TS200)

    # Calibration values from JR230.ecs Beware that Echoview
    # measures pulse length in mS not seconds!

    Sv38cal = Sv(ps38;
                 frequency=38000,
                 gain=25.9400,
                 equivalentbeamangle=-20.700001,
                 soundvelocity=1462.0,
                 absorptioncoefficient=0.001014,
                 transmitpower=2000.00000,
                 pulselength=0.001024,
                 sacorrection=0.12)[2:end,:]

    filename = "JR230-D20091215-T121917-38-cal.sv.csv"
    A = load_echoview_matrix(filename)
    @test compare(A, Sv38cal)

    Sv120cal = Sv(ps120;
                  frequency=120000,
                  gain=21.950,
                  equivalentbeamangle=-20.700001,
                  soundvelocity=1462.0,
                  absorptioncoefficient=0.02683,
                  transmitpower=500.00000,
                  pulselength=0.001024,
                  sacorrection=-0.05)[2:end,:]

    filename = "JR230-D20091215-T121917-120-cal.sv.csv"
    A = load_echoview_matrix(filename)
    @test compare(A, Sv120cal)

    Sv200cal = Sv(ps200;
                  frequency=200000,
                  gain=23.9900,
                  equivalentbeamangle=-19.600000,
                  soundvelocity=1462.0,
                  absorptioncoefficient=0.04023,
                  transmitpower=300.00000,
                  pulselength=0.001024,
                  sacorrection=0.080)[2:end,:]

    filename = "JR230-D20091215-T121917-200-cal.sv.csv"
    A = load_echoview_matrix(filename)
    @test compare(A, Sv200cal)

    TS38cal = TS(ps38;
                 frequency=38000,
                 gain=25.9400,
                 soundvelocity=1462.0,
                 absorptioncoefficient=0.001014,
                 transmitpower=2000.000002)[2:end,:]

    filename = "JR230-D20091215-T121917-38-cal.ts.csv"
    A = load_echoview_matrix(filename)
    @test compare(A, TS38cal)

    TS120cal = TS(ps120;
                  frequency=120000,
                  gain=21.950,
                  soundvelocity=1462.0,
                  absorptioncoefficient=0.02683,
                  transmitpower=500.00000)[2:end,:]

    filename = "JR230-D20091215-T121917-120-cal.ts.csv"
    A = load_echoview_matrix(filename)
    @test compare(A, TS120cal)

    TS200cal = TS(ps200;
                  frequency=200000,
                  gain=23.9900,
                  soundvelocity=1462.0,
                  absorptioncoefficient=0.04023,
                  transmitpower=300.00000)[2:end,:]

    filename = "JR230-D20091215-T121917-200-cal.ts.csv"
    A = load_echoview_matrix(filename)
    @test compare(A, TS200cal)

end
