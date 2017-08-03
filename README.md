# IntegerMask.jl

**IntegerMask.jl** provides optimized methods to work with integer vectors that have the properties that their elements *i* are
1. unique
2. sorted
3. 1 ⩽ *i* ⩽ N.
At its core is the `Mask` type,
```
type Mask{N}
    indices::Vector{Int}
end
```
which is typed onto this maximum number of elements. Currently the following functions are implemented:
* complement: `a'`
* union: `a ∪ b`, `union(a, b)`
* intersect: `a ∩ b`, `intersect(a, b)`
* setdiff: `a \ b`, `setdiff(a, b)`
* in: `i ∈ a`, `in(i, a)`


## Development status

  * Linux/Mac build: [![Travis build status][travis-img]][travis-url]
  * Windows build: [![Windows build status][appveyor-img]][appveyor-url]
  * Test coverage:
        [![Test coverage status on coveralls][coveralls-img]][coveralls-url]
        [![Test coverage status on codecov][codecov-img]][codecov-url]


## Installation

**IntegerMask.jl** is not an officially registered package but it nevertheless can be installed using julia's package manager:

```julia
julia> Pkg.clone("https://github.com/bastikr/IntegerMask.jl.git")
```


[Julia]: http://julialang.org

[travis-url]: https://travis-ci.org/bastikr/IntegerMask.jl
[travis-img]: https://api.travis-ci.org/bastikr/IntegerMask.jl.png?branch=master

[appveyor-url]: https://ci.appveyor.com/project/bastikr/IntegerMask-jl/branch/master
[appveyor-img]: https://ci.appveyor.com/api/projects/status/ajhy6kmf30epfhur/branch/master?svg=true

[coveralls-url]: https://coveralls.io/github/bastikr/IntegerMask.jl?branch=master
[coveralls-img]: https://coveralls.io/repos/github/bastikr/IntegerMask.jl/badge.svg?branch=master

[codecov-url]: https://codecov.io/gh/bastikr/IntegerMask.jl
[codecov-img]: https://codecov.io/gh/bastikr/IntegerMask.jl/branch/master/graph/badge.svg
