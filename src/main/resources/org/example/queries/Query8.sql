-- Q8: For each student and department (with 2+ different course numbers taken),
-- compare the grade in the lowest-level course with the grade in the highest-level course
COPY (
    -- Step 1: split each courseId into department and course number
    WITH studentCourses AS (
        SELECT t.studentId, t.courseId, t.grade, c.gradCourse,
               regexp_extract(t.courseId, '^([a-z]+)', 1) AS dept,
               CAST(regexp_extract(t.courseId, '^[a-z]+([0-9]+)', 1) AS INT) AS courseNum
        FROM transcript t
        JOIN course c ON t.courseId = c.courseId
    ),
    -- Step 2: if several courses share the same number, keep the one with the higher grade
    oneByNumber AS (
        SELECT *
        FROM (
            SELECT *, ROW_NUMBER() OVER (
                       PARTITION BY studentId, dept, courseNum
                       ORDER BY grade DESC, courseId) AS rn
            FROM studentCourses
        )
        WHERE rn = 1
    ),
    -- Step 3: rank courses from lowest to highest level (graduate courses are always highest)
    ranked AS (
        SELECT *,
               ROW_NUMBER() OVER (PARTITION BY studentId, dept
                                  ORDER BY (gradCourse = 1), courseNum)           AS lowRank,
               ROW_NUMBER() OVER (PARTITION BY studentId, dept
                                  ORDER BY (gradCourse = 1) DESC, courseNum DESC) AS highRank,
               COUNT(*)     OVER (PARTITION BY studentId, dept)                   AS numCourses
        FROM oneByNumber
    )
    -- Step 4: put the lowest and highest course side by side
    SELECT s.firstName || ' ' || s.lastName                AS fullName,
           lo.dept                                         AS department,
           '(' || lo.courseId || ', ' || hi.courseId || ')' AS coursePair,
           '(' || lo.grade    || ', ' || hi.grade    || ')' AS gradePair
    FROM ranked lo
    JOIN ranked hi  ON lo.studentId = hi.studentId AND lo.dept = hi.dept
    JOIN student s  ON lo.studentId = s.studentId
    WHERE lo.lowRank = 1
      AND hi.highRank = 1
      AND lo.numCourses >= 2
    ORDER BY fullName, department
) TO 'src/main/resources/data/output/query8.csv' (HEADER, DELIMITER ',');