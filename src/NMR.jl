# Starting point for NMR work in Julia

module NMR

using Interpolations

struct ProcessedSpectrum
    re_ft :: Vector{Int32}
    im_ft :: Vector{Int32}
    params :: Dict{AbstractString, Any}
    intrng :: Vector{Tuple{Float64, Float64}}
end

Base.getindex(p::ProcessedSpectrum, param::AbstractString) = p.params[param]

struct Spectrum
    fid :: Vector{Int32}
    acqu :: Dict{AbstractString, Any}
    procs :: Dict{Int,ProcessedSpectrum}
    default_proc :: Int
end

Base.getindex(s::Spectrum, i::Int) = s.procs[i]
function Base.getindex(s::Spectrum, param::AbstractString)
    try
        s.acqu[param]
    catch err
        s[s.default_proc][param]
    end
end

Spectrum(fid :: Vector{Int32}, acqu :: Dict{Any, Any}, proc :: ProcessedSpectrum) = Spectrum(fid, acqu, Dict(1=>proc), default_proc = 1)

include("analysis.jl")
include("bruker.jl")
include("interpolation.jl")
include("utils.jl")


export read_bruker_binary, acq_params, interpolate_spect, analyze_lsq

end
