using Base.Test

using IntegerMask

@testset "mask" begin

# copy
inds = [2, 3]
m1 = Mask{4}(inds)
m2 = copy(m1)
push!(inds, 4)

@test m1.indices == [2, 3, 4]
@test m2.indices == [2, 3]


# length
@test length(Mask{10}()) == 0
@test length(Mask{3}(1, 2)) == 2


# equality
@test Mask{3}(1, 2) == Mask{3}(1, 2)
@test Mask{3}(1, 2) != Mask{3}(3)


# getindex array[mask]
@test_throws AssertionError (1:10)[Mask{9}(1)]
@test (1:10)[Mask{10}(1, 3, 7)] == [1, 3, 7]


# getindex mask[mask]
@test Mask{4}(1, 3, 4)[Mask{4}()] == Mask{0}()
@test Mask{4}(1, 3, 4)[Mask{4}(2, 3)] == Mask{2}(2)
@test Mask{4}(1, 3, 4)[Mask{4}(1, 2, 3)] == Mask{3}(1, 3)


# complement
@test Mask{3}(1, 2)' == Mask{3}(3)
@test Mask{5}(3)' == Mask{5}(1, 2, 4, 5)
@test Mask{4}(1, 2, 3, 4)' == Mask{4}()


# union
@test Mask{2}() ∪ Mask{2}() == Mask{2}()
@test Mask{2}() ∪ Mask{2}(1) == Mask{2}(1)
@test Mask{2}(1) ∪ Mask{2}() == Mask{2}(1)
@test Mask{4}(1, 3) ∪ Mask{4}(2, 3) == Mask{4}(1, 2, 3)
@test Mask{4}(2, 4) ∪ Mask{4}(3, 4) == Mask{4}(2, 3, 4)


# intersect
@test Mask{2}() ∩ Mask{2}() == Mask{2}()
@test Mask{2}() ∩ Mask{2}(1) == Mask{2}()
@test Mask{2}(1) ∩ Mask{2}() == Mask{2}()
@test Mask{4}(1, 3) ∩ Mask{4}(2, 3) == Mask{4}(3)
@test Mask{4}(2, 3) ∩ Mask{4}(1, 3) == Mask{4}(3)
@test Mask{4}(2, 4) ∩ Mask{4}(3, 4) == Mask{4}(4)
@test Mask{6}(1, 3, 5, 6) ∩ Mask{6}(2, 3, 4) == Mask{6}(3)
@test Mask{6}(2, 3, 4) ∩ Mask{6}(1, 3, 5, 6) == Mask{6}(3)


# setdiff
@test Mask{2}() \ Mask{2}() == Mask{2}()
@test Mask{2}() \ Mask{2}(1) == Mask{2}()
@test Mask{2}(1) \ Mask{2}() == Mask{2}(1)
@test Mask{4}(1, 3) \ Mask{4}(2, 3) == Mask{4}(1)
@test Mask{4}(2, 4) \ Mask{4}(3, 4) == Mask{4}(2)
@test Mask{4}(2, 3, 4) \ Mask{4}(3, 4) == Mask{4}(2)


# in
@test 1 ∈ Mask{2}(1)
@test 2 ∉ Mask{2}(1)


# sum
@test_throws AssertionError sum([1, 2], Mask{1}())

c = sum(1:4, Mask{4}())
@test isa(c, Int)
@test c == 0

c = sum([1., 2., 3., 4.], Mask{4}())
@test isa(c, Float64)
@test c == 0

c = sum(complex([1., 2., 3., 4.]), Mask{4}())
@test isa(c, Complex128)
@test c == 0

@test sum(1:4, Mask{4}(2, 4)) == 6


# prod
@test_throws AssertionError prod([1, 2], Mask{1}())

c = prod(1:4, Mask{4}())
@test isa(c, Int)
@test c == 1

c = prod([1., 2., 3., 4.], Mask{4}())
@test isa(c, Float64)
@test c == 1

c = prod(complex([1., 2., 3., 4.]), Mask{4}())
@test isa(c, Complex128)
@test c == 1

@test prod(1:4, Mask{4}(2, 4)) == 8

end # testset
