-- # Scans and reductions
--
-- The `reduce` function reduces an array to a single value by
-- conceptually inserting a binary operator (or any two-parameter
-- function) between each element.
--
-- ```
--    reduce (+) 0 [1, 2, 3, 4]
-- == [1 + 2 + 3 + 4]
-- == 10
-- ```
--
-- We can use them to define a function for computing averages:

let average (xs: []f64) =
  reduce (+) 0.0 xs / f64.i64 (length xs)

-- There are some restrictions to enable parallel execution.  In an
-- expression `reduce f ne xs`, the function `f` must be
-- [associative](https://en.wikipedia.org/wiki/Commutative_property)
-- and have `ne` as neutral element.  Intuitively, associativity means
-- that we can move around the parantheses in an application:
--
-- ```
-- f (f x y) z == f x (f y z)
-- ```
--
-- It's a bit easier to understand if we write the function as an
-- infix operator instead:
--
-- ```
-- (x + y) + z == x + (y + z)
-- ```
--
-- `ne` being a neutral element means that it does not affect the
-- result of the function:
--
-- ```
-- f x ne == f ne x == x
-- ```
--
-- As a simple example, 0 is the neutral element for addition, and 1
-- for multiplication.
--
-- If we pass `reduce` a function that is not associative, or does not
-- have the provided neutral element, we will get wrong results at
-- run-time.  What's worse, the compiler will not be able to detect
-- that we messed up (it's actually impossible in general), however
-- [techniques exist for testing associativity
-- empirically](testing-associativity.html).  You can also [invent a
-- neutral element if necessary](no-neutral-element.html).
--
-- Scans (also called [prefix
-- sums](https://en.wikipedia.org/wiki/Prefix_sum)) are similar to
-- reductions, but rather than producing a single result, they produce
-- an array of the same size as the input, where each element is
-- conceptually a reduction of a prefix of the array:
--
-- ```
--    scan (+) 0 [1, 2, 3, 4]
-- == [reduce (+) 0 [1],
--     reduce (+) 0 [1,2],
--     reduce (+) 0 [1,2,3],
--     reduce (+) 0 [1,2,3,4]]
-- == [1, 3, 6, 10]
-- ```
--
-- Somewhat surprisingly, these can also be efficiently computed in
-- parallel, and have the same restrictions with respect to
-- associativity and a neutral element as `reduce`.  For now, scans
-- may look a bit exotic, and they certainly are, but we'll return to
-- them in other examples, as they are an important building block in
-- advanced parallel algorithms.
