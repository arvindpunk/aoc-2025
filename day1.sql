--part a
SELECT
    arrayFold(
        acc,
        el -> (
            (acc.1 + el + 100 * 1000000) % 100 :: Int64,
            acc.2 + ((acc.1 + el + 100 * 1000000) % 100 = 0)
        ),
        groupArray(
            toInt64(replaceOne(replaceOne(line, 'L', '-'), 'R', ''))
        ),
        (50 :: Int64, 0 :: UInt64)
    ).2
FROM
    "table"