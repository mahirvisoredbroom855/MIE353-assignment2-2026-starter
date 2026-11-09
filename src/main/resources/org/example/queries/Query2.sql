-- Q2: Names of all fourth-year courses
COPY (
    SELECT courseId, courseName
    FROM course
    WHERE regexp_matches(courseId, '^[a-z]+4[0-9]{2}[a-z]')
    ORDER BY courseId
) TO 'src/main/resources/data/output/query2.csv' (HEADER, DELIMITER ',');