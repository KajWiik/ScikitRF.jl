using ScikitRF
using Test
using PythonCall: pyconvert

@testset "ScikitRF.jl Tests" begin
    
    @testset "Module Loading" begin
        # Test that the module loads
        @test ScikitRF isa Module
        
        # Test that main classes are available
        @test isdefined(ScikitRF, :Network)
        @test isdefined(ScikitRF, :Frequency)
        @test isdefined(ScikitRF, :NetworkSet)
    end
    
    @testset "Frequency Creation" begin
        # Create a frequency object
        freq = Frequency(1, 10, 101, "GHz")
        
        # Check that it was created
        @test !isnothing(freq)
        
        # Check basic properties
        @test pyconvert(Int, freq.npoints) == 101
    end
    
    @testset "Empty Network Creation" begin
        # Create an empty network
        nw = Network()
        
        # Check that it was created
        @test !isnothing(nw)
    end
    
    @testset "Conversion Functions Available" begin
        # Test that conversion functions are exported
        @test isdefined(ScikitRF, :s2z)
        @test isdefined(ScikitRF, :s2y)
        @test isdefined(ScikitRF, :z2s)
        @test isdefined(ScikitRF, :y2z)
    end
    
    @testset "Network Operations Available" begin
        # Test that network operations are exported
        @test isdefined(ScikitRF, :cascade)
        @test isdefined(ScikitRF, :connect)
        @test isdefined(ScikitRF, :average)
        @test isdefined(ScikitRF, :flip)
    end
    
    @testset "Calibration Classes Available" begin
        # Test that calibration classes are exported
        @test isdefined(ScikitRF, :SOLT)
        @test isdefined(ScikitRF, :TRL)
        @test isdefined(ScikitRF, :LRM)
    end
    
    @testset "Media Classes Available" begin
        # Test that media classes are exported
        @test isdefined(ScikitRF, :Freespace)
        @test isdefined(ScikitRF, :RectangularWaveguide)
    end
    
    @testset "Utility Functions Available" begin
        # Test that utility functions are exported
        @test isdefined(ScikitRF, :complex_2_db)
        @test isdefined(ScikitRF, :mag_2_db)
        @test isdefined(ScikitRF, :db_2_mag)
    end
    
    @testset "Constants Available" begin
        # Test that constants are exported
        @test isdefined(ScikitRF, :c)
        @test isdefined(ScikitRF, :inch)
        @test isdefined(ScikitRF, :mil)
    end
    
    @testset "Basic Calculations" begin
        # Test some basic conversion functions
        mag = 2.0
        db = mag_2_db(mag)
        @test !isnothing(db)
        
        # Test conversion back
        mag2 = db_2_mag(db)
        @test isapprox(mag, pyconvert(Float64, mag2), atol=1e-10)
    end
end
