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
    "table";

--part b
SELECT
    arrayFold(
        acc,
        el -> (
            (acc.1 + el + 100 * 1000000) % 100 :: Int64,
            acc.2 + multiIf(
                acc.1 + el >= 100,
                intDiv(acc.1 + el, 100),
                acc.1 + el <= 0,
                IF(acc.1 = 0, 0, 1) + intDiv(-1 * (acc.1 + el), 100),
                0
            )
        ),
        groupArray(
            toInt64(replaceOne(replaceOne(line, 'L', '-'), 'R', ''))
        ),
        (50 :: Int64, 0 :: Int64)
    ).2
FROM
    "table";