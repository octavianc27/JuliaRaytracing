struct Interval
    min::Float64
    max::Float64
end

function Interval()
    Interval(-Inf64, Inf64)
end

function Interval(a::Interval, b::Interval)
    return Interval(min(a.min, b.min), max(a.max, b.max))
end

function contains(int::Interval, x::Float64)
    return int.min <= x && x <= int.max
end

function surrounds(int::Interval, x::Float64)
    return int.min < x && x < int.max
end

function extend(int::Interval, delta::Float64)
    padding = delta/2
    return interval(int.min - padding, int.max + padding)
end
