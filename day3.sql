--part a
SELECT
    sum(
        arrayMax(
            arrayMap(
                x -> x * hasSubsequence(line, toString(x)),
                `range`(10, 100)
            )
        )
    )
FROM
    "table";

--part b