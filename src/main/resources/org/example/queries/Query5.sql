-- Q5: Professors (who teach at least one course) that have never given a failing grade (49 or below)
COPY (
    SELECT DISTINCT p.firstName || ' ' || p.lastName AS fullName
    FROM professor p
    JOIN teaches te ON p.profId = te.profId
    WHERE NOT EXISTS (
        SELECT 1
        FROM teaches te2
        JOIN transcript t ON te2.courseId = t.courseId
        WHERE te2.profId = p.profId
          AND t.grade <= 49
    )
    ORDER BY fullName
) TO 'src/main/resources/data/output/query5.csv' (HEADER, DELIMITER ',');