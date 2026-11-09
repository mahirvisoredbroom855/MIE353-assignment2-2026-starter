package org.example;

// General Helper Imports
import manifold.sql.rt.api.Dependencies.*;
import java.sql.SQLException;
import java.util.List;
import static java.lang.System.out;
import java.nio.file.*;


// Import all defined queries
import org.example.queries.*;

// Import schema classes
import org.example.schema.CMS;
import org.example.schema.CMS.*;



public class Main {
    public static void main(String[] args) {

      try {
        // Load in all the data from CSV files in to in-memory DuckDB
        loadCMSData();

        // Example: fetch a student by ID and print their email
        Student s = Student.fetch(9002);
        out.println(s.getEmail());
        // Example: fetch the same student using a parameterized SQL query
        Student s2 = FindStudent.fetchOne(9002);
        out.println(s2.getEmail());

        //Example: saving a table to CSV
        CMS.addSqlChange(ctx -> {
          SaveStudents.execute(ctx);
        });
        CMS.commit();
        
        // EXTRA MAIN FUNCTION CALLS CAN GO BELOW:

        // Section 3: get graduate courses and save them to gradCourses.csv
        getGradCourses();

        // Section 4: run each query and save results to query1.csv ... query8.csv
        runQuery1();
        runQuery2();
        runQuery3();
        runQuery4();
        runQuery5();
        runQuery6();
        runQuery7();
        runQuery8();

      }
      catch (Exception e) {
        e.printStackTrace();
      }


  }

  public static void loadCMSData() throws SQLException {
    loadStudentData();
    loadProfessorData();
    loadCourseData();
    loadTranscriptData();
    loadTeachesData(); // Section 2: loaded last since it depends on professor and course
  }

  public static void loadStudentData() throws SQLException {
    CMS.addSqlChange(ctx -> {
      LoadStudents.execute(ctx);
    });
    CMS.commit();
  }

  public static void loadProfessorData() throws SQLException {
    CMS.addSqlChange(ctx -> {
      LoadProfessors.execute(ctx);
    });
    CMS.commit();
  }

  public static void loadCourseData() throws SQLException {
    CMS.addSqlChange(ctx -> {
      LoadCourses.execute(ctx);
    });
    CMS.commit();
  }

  public static void loadTranscriptData() throws SQLException {
    CMS.addSqlChange(ctx -> {
      LoadTranscript.execute(ctx);
    });
    CMS.commit();
  }

  // Section 2: loads teaches.csv into the teaches table
  public static void loadTeachesData() throws SQLException {
    CMS.addSqlChange(ctx -> {
      LoadTeaches.execute(ctx);
    });
    CMS.commit();
  }

  // Section 3: returns the courses graduate students can enrol in
  // (graduate-level and 500-level) and saves them to output/gradCourses.csv
  public static Iterable<FindGradCourses.Row> getGradCourses() throws SQLException {
    CMS.addSqlChange(ctx -> {
      SaveGradCourses.execute(ctx);
    });
    CMS.commit();

    return FindGradCourses.fetch();
  }

  // Section 4 - Q1: number of students with 80+ in mie301h1f
  public static void runQuery1() throws SQLException {
    CMS.addSqlChange(ctx -> {
      Query1.execute(ctx, "mie301h1f", 80);
    });
    CMS.commit();
  }

  // Section 4 - Q2: names of fourth-year courses
  public static void runQuery2() throws SQLException {
    CMS.addSqlChange(ctx -> {
      Query2.execute(ctx);
    });
    CMS.commit();
  }

  // Section 4 - Q3: professors teaching exactly one course
  public static void runQuery3() throws SQLException {
    CMS.addSqlChange(ctx -> {
      Query3.execute(ctx);
    });
    CMS.commit();
  }

  // Section 4 - Q4: professors who taught a course taken by Rebecca Ward
  public static void runQuery4() throws SQLException {
    CMS.addSqlChange(ctx -> {
      Query4.execute(ctx, "Rebecca", "Ward");
    });
    CMS.commit();
  }

  // Section 4 - Q5: professors who never gave a failing grade
  public static void runQuery5() throws SQLException {
    CMS.addSqlChange(ctx -> {
      Query5.execute(ctx);
    });
    CMS.commit();
  }

  // Section 4 - Q6: Data Modelling students with 90+ in another course
  public static void runQuery6() throws SQLException {
    CMS.addSqlChange(ctx -> {
      Query6.execute(ctx);
    });
    CMS.commit();
  }

  // Section 4 - Q7: pairs of students with 3+ courses in common
  public static void runQuery7() throws SQLException {
    CMS.addSqlChange(ctx -> {
      Query7.execute(ctx);
    });
    CMS.commit();
  }

  // Section 4 - Q8: lowest vs highest level course grade per student and department
  public static void runQuery8() throws SQLException {
    CMS.addSqlChange(ctx -> {
      Query8.execute(ctx);
    });
    CMS.commit();
  }
}