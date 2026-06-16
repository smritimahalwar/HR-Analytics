DROP DATABASE if exists hr_analytics;
CREATE database hr_analytics;
USE hr_analytics;
CREATE TABLE employee_data (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(20),
    age INT,
    department VARCHAR(100),
    position VARCHAR(100),
    salary INT,
    start_date VARCHAR(20),
    email VARCHAR(100)
);
SELECT COUNT(*) FROM employee_data;

-- 1. Total Headcount
SELECT COUNT(*) AS total_employees 
FROM employee_data;

-- 2. Departmental Breakdown
SELECT department, COUNT(*) AS employee_count 
FROM employee_data 
GROUP BY department 
ORDER BY employee_count DESC;

-- 3. Gender Diversity
SELECT gender, COUNT(*) AS count, 
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM employee_data), 2) AS percentage
FROM employee_data 
GROUP BY gender;

-- 4. Average Age of the Workforce
SELECT ROUND(AVG(age), 1) AS average_age 
FROM employee_data;

-- 5. Overall Salary Metrics
SELECT MIN(salary) AS min_salary, 
       MAX(salary) AS max_salary, 
       ROUND(AVG(salary), 2) AS avg_salary 
FROM employee_data;
-- 6. Top Paid Departments (Highest average salary)
SELECT department, 
       ROUND(AVG(salary), 2) AS average_salary,
       COUNT(*) AS total_employees
FROM employee_data 
GROUP BY department 
ORDER BY average_salary DESC;

-- 7. Role Counts (See what positions exist and how common they are)
SELECT position, COUNT(*) AS employee_count 
FROM employee_data 
GROUP BY position 
ORDER BY employee_count DESC;

-- 8. High Earners (Employees earning above the company-wide average salary)
SELECT employee_id, first_name, last_name, department, salary 
FROM employee_data 
WHERE salary > (SELECT AVG(salary) FROM employee_data)
ORDER BY salary DESC;

-- 9. Salary Disparity by Gender (Average salary for each gender)
SELECT gender, 
       ROUND(AVG(salary), 2) AS average_salary,
       MIN(salary) AS min_salary,
       MAX(salary) AS max_salary
FROM employee_data 
GROUP BY gender;

-- 10. Departmental Gender Split (Count of males and females in each department)
SELECT department,
       SUM(CASE WHEN gender = 'Male' THEN 1 ELSE 0 END) AS male_count,
       SUM(CASE WHEN gender = 'Female' THEN 1 ELSE 0 END) AS female_count
FROM employee_data
GROUP BY department;

-- 11. The Veterans (Top 5 longest-serving employees)
SELECT employee_id, first_name, last_name, department, position, 
       STR_TO_DATE(start_date, '%d-%m-%y') AS clean_start_date
FROM employee_data
ORDER BY clean_start_date ASC
LIMIT 5;

-- 12. Hiring Trends Over Time (Count how many employees were hired each year)
SELECT YEAR(STR_TO_DATE(start_date, '%d-%m-%y')) AS hire_year,
       COUNT(*) AS employees_hired
FROM employee_data
GROUP BY hire_year
ORDER BY hire_year DESC;

-- 13. Analysis of Recent Hires (List employees hired after January 1, 2021)
SELECT first_name, last_name, department, position, STR_TO_DATE(start_date, '%d-%m-%y') AS hire_date
FROM employee_data
WHERE STR_TO_DATE(start_date, '%d-%m-%y') >= '2021-01-01'
ORDER BY hire_date;

-- 14. Senior vs. Junior Workforce Age Demographics
-- This checks the average age of employees based on whether their title contains 'Senior' or 'Junior'
SELECT 
    CASE 
        WHEN position LIKE '%Senior%' THEN 'Senior Roles'
        WHEN position LIKE '%Junior%' THEN 'Junior Roles'
        ELSE 'Regular/Manager Roles'
    END AS role_level,
    ROUND(AVG(age), 1) AS average_age,
    COUNT(*) AS total_employees
FROM employee_data
GROUP BY role_level;

-- 15. Salary Disparity Within the Engineering Department
-- Finds the exact gap between the highest and lowest earner in Engineering
SELECT MAX(salary) AS max_eng_salary,
       MIN(salary) AS min_eng_salary,
       (MAX(salary) - MIN(salary)) AS salary_gap
FROM employee_data
WHERE department = 'Engineering';

-- 16. Department Salary Ranking 
-- This ranks employees by salary *within* their own department.
SELECT department, first_name, last_name, salary,
       DENSE_RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS salary_rank
FROM employee_data;

-- 17. Age Categorization & Compensation (Conditional Logic)
-- Groups employees into generation buckets to see which age bracket costs the most in payroll
SELECT 
    CASE 
        WHEN age < 30 THEN 'Under 30'
        WHEN age BETWEEN 30 AND 45 THEN '30-45'
        ELSE 'Over 45'
    END AS age_group,
    COUNT(*) AS employee_count,
    ROUND(AVG(salary), 2) AS average_salary
FROM employee_data
GROUP BY age_group
ORDER BY age_group;

-- 18. Department Budget Contribution Percentage
-- Shows what percentage of the company's total payroll budget is consumed by each department
SELECT department,
       SUM(salary) AS total_department_payroll,
       ROUND(SUM(salary) * 100.0 / (SELECT SUM(salary) FROM employee_data), 2) AS percent_of_total_budget
FROM employee_data
GROUP BY department
ORDER BY percent_of_total_budget DESC;

-- 19. Data Integrity & Duplicate Check
-- A crucial step in any data project: ensuring there are no duplicate email addresses
SELECT email, COUNT(*) as occurrences
FROM employee_data
GROUP BY email
HAVING occurrences > 1;

-- 20. Running Total of Corporate Payroll (Cumulative Sum Window Function)
-- Calculates how the company's annual salary commitments grew as new people were hired over time
SELECT STR_TO_DATE(start_date, '%d-%m-%y') AS hire_date,
       first_name, last_name, salary,
       SUM(salary) OVER(ORDER BY STR_TO_DATE(start_date, '%d-%m-%y')) AS cumulative_payroll_running_total
FROM employee_data;