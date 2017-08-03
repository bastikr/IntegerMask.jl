module IntegerMask

export Mask

import Base: ==, \


type Mask{N}
    indices::Vector{Int}
end

Mask{N}(indices::Int...) where N = Mask{N}(Int[indices...])

Base.copy{N}(m::Mask{N}) = Mask{N}(copy(m.indices))

=={N}(m1::Mask{N}, m2::Mask{N}) = m1.indices == m2.indices


function Base.getindex{N}(a::AbstractArray, m::Mask{N})
    @assert length(a) == N
    @inbounds result = a[m.indices]
    result
end

function Base.getindex{N}(m1::Mask{N}, m2::Mask{N})
    _indices = Int[]
    @inbounds for i=1:length(m2.indices)
        if m2.indices[i] ∈ m1.indices
            push!(_indices, i)
        end
    end
    Mask{length(m2.indices)}(_indices)
end

function Base.transpose{N}(m::Mask{N})
    L = length(m.indices)
    x = Vector{Int}(N - L)
    i_ = 1 # Position in the x vector
    j = 1 # Position in indices vector
    @inbounds for i=1:N
        if j > L || m.indices[j]!=i
            x[i_] = i
            i_ += 1
        else
            j += 1
        end
    end
    Mask{N}(x)
end

function Base.union{N}(m1::Mask{N}, m2::Mask{N})
    xvec = Vector{Int}()
    result = Mask{N}(xvec)
    ind1 = m1.indices
    ind2 = m2.indices
    i1 = 1
    i2 = 1
    N1 = length(ind1)
    N2 = length(ind2)
    @inbounds while true
        if i1 > N1
            for j=i2:N2
                push!(xvec, ind2[j])
            end
            return result
        elseif i2 > N2
            for j=i1:N1
                push!(xvec, ind1[j])
            end
            return result
        end
        x1 = ind1[i1]
        x2 = ind2[i2]
        if x1 == x2
            i1 += 1
            i2 += 1
            push!(xvec, x1)
        elseif x1 < x2
            i1 += 1
            push!(xvec, x1)
        else
            i2 += 1
            push!(xvec, x2)
        end
    end
end

function Base.intersect{N}(m1::Mask{N}, m2::Mask{N})
    xvec = Vector{Int}()
    result = Mask{N}(xvec)
    ind1 = m1.indices
    ind2 = m2.indices
    i1 = 1
    i2 = 1
    N1 = length(ind1)
    N2 = length(ind2)
    if i1 > N1 || i2 > N2
        return result
    end
    x1 = ind1[i1]
    x2 = ind2[i2]
    @inbounds while true
        if x1 == x2
            i1 += 1
            i2 += 1
            push!(xvec, x1)
            if i1 > N1 || i2 > N2
                return result
            end
            x1 = ind1[i1]
            x2 = ind2[i2]
        elseif x1 < x2
            i1 += 1
            if i1 > N1
                return result
            end
            x1 = ind1[i1]
        else
            i2 += 1
            if i2 > N2
                return result
            end
            x2 = ind2[i2]
        end
    end
end

function Base.setdiff{N}(m1::Mask{N}, m2::Mask{N})
    Mask{N}(setdiff(m1.indices, m2.indices))
end

\{N}(m1::Mask{N}, m2::Mask{N}) = setdiff(m1, m2)

Base.in{N}(i::Int, m2::Mask{N}) = in(i, m2.indices)

function Base.prod{N}(a::AbstractArray, m::Mask{N})
    @assert length(a) == N
    c = one(eltype(a))
    @inbounds for i in m.indices
        c *= a[i]
    end
    c
end

function Base.sum{N}(a::AbstractArray, m::Mask{N})
    @assert length(a) == N
    c = zero(eltype(a))
    @inbounds for i in m.indices
        c += a[i]
    end
    c
end

end #module
