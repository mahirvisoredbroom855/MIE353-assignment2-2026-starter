CREATE TABLE IF NOT EXISTS teaches (
    profId   INT NOT NULL,
    courseId VARCHAR(20) NOT NULL,
    PRIMARY KEY (profId, courseId),
    FOREIGN KEY (profId) REFERENCES professor(profId),
    FOREIGN KEY (courseId) REFERENCES course(courseId)
);
COPY teaches FROM 'src/main/resources/data/teaches.csv';