COPY (
    SELECT courseId, courseName
    FROM course
    WHERE gradCourse IN (1, 2)
    ORDER BY courseId
) TO 'src/main/resources/data/output/gradCourses.csv' (HEADER, DELIMITER ',');