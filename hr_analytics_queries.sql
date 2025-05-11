#Analyze average salary by department and job title to assess department-level compensation trends.
SELECT 
    d.department_name,
    j.job_title,
    COUNT(e.employee_id) AS num_employees,
    ROUND(AVG(e.salary), 2) AS avg_salary,
    ROUND(MIN(e.salary), 2) AS min_salary,
    ROUND(MAX(e.salary), 2) AS max_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN jobs j ON e.job_id = j.job_id
GROUP BY d.department_name, j.job_title
ORDER BY d.department_name, avg_salary DESC;

#Validate that employee salaries fall within the allowed job salary range.
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    j.job_title,
    e.salary,
    j.min_salary,
    j.max_salary
FROM employees e
JOIN jobs j ON e.job_id = j.job_id
WHERE e.salary < j.min_salary OR e.salary > j.max_salary;

#Understand how employees are distributed globally to support resource planning.
SELECT 
    r.region_name,
    COUNT(e.employee_id) AS total_employees
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id
JOIN countries c ON l.country_id = c.country_id
JOIN regions r ON c.region_id = r.region_id
GROUP BY r.region_name
ORDER BY total_employees DESC;

#Analyze how long employees have been with the company for retention planning.
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    DATEDIFF(CURDATE(), e.hire_date) / 365 AS years_with_company
FROM employees e
ORDER BY years_with_company DESC;

#Analyze family-dependency trends across departments to support HR benefits planning.
SELECT 
    d.department_name,
    COUNT(DISTINCT e.employee_id) AS num_employees,
    COUNT(dep.dependent_id) AS num_dependents,
    ROUND(COUNT(dep.dependent_id) / COUNT(DISTINCT e.employee_id), 2) AS dependent_per_employee
FROM departments d
JOIN employees e ON d.department_id = e.department_id
LEFT JOIN dependents dep ON e.employee_id = dep.employee_id
GROUP BY d.department_name
ORDER BY dependent_per_employee DESC;