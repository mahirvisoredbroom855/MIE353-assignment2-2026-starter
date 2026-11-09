-- Q4: Full names of professors who taught at least one course taken by a given student
COPY (
    SELECT DISTINCT p.firstName || ' ' || p.lastName AS fullName
    FROM student s
    JOIN transcript t ON s.studentId = t.studentId
    JOIN teaches te   ON t.courseId  = te.courseId
    JOIN professor p  ON te.profId   = p.profId
    WHERE s.firstName = :firstName
      AND s.lastName  = :lastName
    ORDER BY fullName
) TO 'src/main/resources/data/output/query4.csv' (HEADER, DELIMITER ',');