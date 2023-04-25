# ScienceQtech Employee Performance Mapping 

/* Create a database named employee*/
CREATE DATABASE IF NOT EXISTS  employee;	
USE employee;

/* Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT 
# from the employee record table, and make a list of employees and details of their department.*/
SELECT emp_id, first_name, last_name, gender, dept
FROM emp_record_table;

/* Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: 
#less than two # greater than four # between two and four*/
SELECT first_name, last_name, gender, dept, emp_rating
FROM emp_record_table
WHERE emp_rating <2;
# greater than four #
SELECT first_name, last_name, gender, dept, emp_rating
FROM emp_record_table
WHERE emp_rating > 4;
# between two and four
SELECT first_name, last_name, gender, dept, emp_rating
FROM emp_record_table
WHERE emp_rating BETWEEN 2 AND 4;

/* Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in 
#the Finance department from the employee table and then give the resultant column alias as NAME*/
SELECT concat(first_name, '',last_name) AS name
FROM emp_record_table
WHERE dept = 'Finance';

/* Write a query to list only those employees who have someone reporting to them. 
Also, show the number of reporters (including the President).*/
SELECT 
    CONCAT(emp_record_table.first_name, ' ', emp_record_table.last_name) AS emp_name,
    COUNT(DISTINCT emp_record_table.emp_id) AS num_reporters
FROM 
    emp_record_table
    JOIN 
    emp_record_table AS reporters ON emp_record_table.emp_id = reporters.manager_id 
        OR (emp_record_table.manager_id IS NULL AND emp_record_table.emp_id = reporters.manager_id)
GROUP BY 
    emp_record_table.emp_id, emp_record_table.first_name, emp_record_table.last_name
HAVING 
    COUNT(DISTINCT emp_record_table.emp_id) > 0
ORDER BY 
    emp_record_table.emp_id;

/* Write a query to list down all the employees from the healthcare and finance departments using union. 
Take data from the employee record table*/
SELECT * FROM employee.emp_record_table WHERE DEPT="Finance"
UNION
SELECT * FROM employee.emp_record_table WHERE DEPT="Healthcare";

/*  Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING grouped by dept. 
 Also include the respective employee rating along with the max emp rating for the department*/
SELECT  emp_id, first_name,last_name,role,dept,emp_rating,max(emp_rating)
OVER(PARTITION BY dept)
AS "Max_Dept_Rating"
FROM emp_record_table
ORDER BY dept asc;

/* Write a query to calculate the minimum and the maximum salary of the employees in each role. Take data from the employee record table*/
SELECT role, MAX(salary) AS max_salary, MIN(salary) AS min_salary 
FROM emp_record_table
GROUP BY role
ORDER BY role;

/* Write a query to assign ranks to each employee based on their experience. Take data from the employee record table.*/
SELECT *,
RANK() OVER( order by EXP) as 'rank'
FROM emp_record_table;

/* Write a query to create a view that displays employees in various countries whose salary is more than six thousand. 
Take data from the employee record table.*/
CREATE VIEW Employee_view AS 
SELECT emp_id, first_name,last_name,country,dept,salary
FROM emp_record_table
WHERE salary > 6000;

/* Write a nested query to find employees with experience of more than ten years. Take data from the employee record table.*/
SELECT *
FROM emp_record_table
WHERE exp > 10;

/* Write a query to create a stored procedure to retrieve the details of the employees whose experience is more than three years. 
Take data from the employee record table.*/
DELIMITER &&
CREATE PROCEDURE experience_details()
BEGIN
SELECT emp_id,first_name,last_name,exp 
FROM emp_record_table
WHERE exp>3;
END &&
CALL experience_details();

/* Write a query using stored functions in the project table to check whether the job profile assigned to each employee in the data science 
team matches the organization’s set standard. The standard being:a) For an employee with experience less than or equal to 2 years assign 
'JUNIOR DATA SCIENTIST', b) For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST', c) For an employee with the 
experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST', d) For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST',
e) For an employee with the experience of 12 to 16 years assign 'MANAGER'.*/

DELIMITER &&
CREATE FUNCTION jobprofile_match(
exp INT
)
RETURNS VARCHAR(250)
DETERMINISTIC
BEGIN
DECLARE standard_role VARCHAR(250);
IF exp < 2 THEN SET standard_role ='Junior Data Scientist';
ELSEIF ( EXP >=2 and EXP <5) THEN SET STANDARD_ROLE ='Associate Data Scientist';
ELSEIF ( EXP >=5 and EXP <10) THEN SET STANDARD_ROLE ='Senior Data Scientist';
ELSEIF ( EXP >=10 and EXP <12) THEN SET STANDARD_ROLE ='Lead Data Scientist';
ELSEIF ( EXP >=12 and EXP <16) THEN SET STANDARD_ROLE ='Manager';
END IF;
RETURN (STANDARD_ROLE);
END &&

SELECT exp, jobprofile_match(EXP)
FROM data_science_team;

/* Create an index to improve the cost and performance of the query to find the employee whose FIRST_NAME is ‘Eric’ 
in the employee table after checking the execution plan.*/
CREATE INDEX idx_frst_name
ON emp_record_table(First_name(25));
SELECT * FROM emp_record_table
WHERE First_name='Eric';
#Checking indexes
SHOW INDEXES FROM emp_record_table;

/* Write a query to calculate the bonus for all the employees, based on their ratings and salaries 
(Use the formula: 5% of salary * employee rating).*/
SELECT emp_id, first_name, last_name, salary, emp_rating, round((0.05 * salary * emp_rating),0) AS Bonus, (salary + round((0.05 * salary * emp_rating),0)) AS Total_salary
FROM emp_record_table
ORDER BY Total_salary asc;

/* Write a query to calculate the average salary distribution based on the continent and country. Take data from the employee record table.*/
SELECT country,continent, ROUND(AVG(salary), 2)
FROM employee.emp_record_table 
GROUP BY country,continent;