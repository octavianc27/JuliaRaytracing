 struct Interval
    min::Float64
    max::Float64
end

 function Interval()
    Interval(-Inf64, Inf64)
end

 function contains(int::Interval, x::Float64)
    return int.min <= x && x <= int.max
end

 function surrounds(int::Interval, x::Float64)
    return int.min < x && x < int.max
end

