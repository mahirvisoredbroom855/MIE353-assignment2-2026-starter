-- Q6: Students who took a course named "Data Modelling" AND got 90+ in at least one other course
COPY (
    SELECT s.firstName || ' ' || s.lastName AS fullName
    FROM student s
    WHERE EXISTS (
        SELECT 1
        FROM transcript t
        JOIN course c ON t.courseId = c.courseId
        WHERE t.studentId = s.studentId
          AND c.courseName = 'Data Modelling'
    )
    AND EXISTS (
        SELECT 1
        FROM transcript t
        JOIN course c ON t.courseId = c.courseId
        WHERE t.studentId = s.studentId
          AND c.courseName <> 'Data Modelling'
          AND t.grade >= 90
    )
    ORDER BY fullName
) TO 'src/main/resources/data/output/query6.csv' (HEADER, DELIMITER ',');