-- Q1: How many students received a grade of 80 or above in a given course?
COPY (
    SELECT COUNT(*) AS numStudents
    FROM transcript
    WHERE courseId = :courseId
      AND grade >= :minGrade
) TO 'src/main/resources/data/output/query1.csv' (HEADER, DELIMITER ',');