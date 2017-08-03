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

end # testset
