--part a
SELECT
    sum(
        arrayJoin(
            arrayMap(
                x -> x * (toInt64(exp10(countDigits(x))) + 1),
                `range`(invalid_lt_a, invalid_lte_b + 1)
            )
        )
    )
FROM
    (
        SELECT
            arrayMap(
                x -> toInt64(x),
                splitByChar('-', arrayJoin(splitByChar(',', line)))
            ) AS query,
            IF(
                countDigits(query [1]) % 2 = 0,
                -- even digits (56, 1234...)
                query [1],
                -- odd digits (8, 673, 12334...)
                toInt64(exp10(countDigits(query [1])))
            ) AS a,
            IF(
                countDigits(query [2]) % 2 = 0,
                -- even digits (56, 1234...)
                query [2],
                -- odd digits (8, 673, 12334...)
                toInt64(exp10(countDigits(query [2]) - 1)) - 1
            ) AS b,
            intDiv(a, toInt64(exp10(countDigits(a) / 2))) AS a_first_half,
            a % toInt64(exp10(countDigits(a) / 2)) AS a_sec_half,
            intDiv(b, toInt64(exp10(countDigits(b) / 2))) AS b_first_half,
            b % toInt64(exp10(countDigits(b) / 2)) AS b_sec_half,
            a_first_half + 1 - (a_first_half >= a_sec_half) AS invalid_lt_a,
            b_first_half - 1 + (b_first_half <= b_sec_half) AS invalid_lte_b
        FROM
            "table"
    );

--part b
SELECT
    sumIf(
        x,
        arraySum(
            arrayMap(
                len -> toInt64(
                    repeat(
                        substring(toString(x), 1, len),
                        intDiv(countDigits(x), len)
                    )
                ) = x,
                `range`(1, 1 + intDiv(countDigits(x), 2))
            )
        ) > 0
    )
FROM
    (
        SELECT
            arrayJoin(`range`(a, b)) AS x
        FROM
            (
                SELECT
                    arrayMap(
                        x -> toInt64(x),
                        splitByChar('-', arrayJoin(splitByChar(',', line)))
                    ) AS query,
                    query [1] AS a,
                    query [2] AS b
                FROM
                    "table"
            )
    );