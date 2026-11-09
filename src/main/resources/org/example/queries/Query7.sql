-- Q7: Pairs of students with at least 3 courses in common,
COPY (
    SELECT s1.firstName || ' ' || s1.lastName AS student1,
           s2.firstName || ' ' || s2.lastName AS student2,
           COUNT(*)                AS commonCourses,
           ROUND(AVG(t1.grade), 2) AS student1AvgGrade,
           ROUND(AVG(t2.grade), 2) AS student2AvgGrade
    FROM transcript t1
    JOIN transcript t2 ON t1.courseId = t2.courseId
                      AND t1.studentId < t2.studentId   -- each pair listed only once
    JOIN student s1 ON t1.studentId = s1.studentId
    JOIN student s2 ON t2.studentId = s2.studentId
    GROUP BY s1.studentId, s1.firstName, s1.lastName,
             s2.studentId, s2.firstName, s2.lastName
    HAVING COUNT(*) >= 3
    ORDER BY commonCourses DESC, student1, student2
) TO 'src/main/resources/data/output/query7.csv' (HEADER, DELIMITER ',');