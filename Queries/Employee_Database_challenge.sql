-- Create a retirement_titles table 
SELECT e.emp_no, e.first_name, e.last_name, t.title, t.from_date, t.to_date 
INTO retirement_titles
FROM employees AS e
LEFT OUTER JOIN titles AS t
ON (e.emp_no = t.emp_no)
WHERE 
	(e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no ASC;

SELECT * FROM retirement_titles;



-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no, to_date DESC;

SELECT * FROM unique_titles;



-- Retrieve the number of employees by their most recent job title who are about to retire
SELECT COUNT(title) AS "count", title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count DESC;

SELECT * FROM retiring_titles;



-- Query to create a Mentorship Eligibility table 
SELECT DISTINCT ON (e.emp_no)
	e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	t.title
INTO mentorship_eligibility
FROM employees AS e
LEFT OUTER JOIN dept_emp AS de
ON (e.emp_no = de.emp_no)
LEFT OUTER JOIN titles as t
ON (e.emp_no = t.emp_no)
WHERE 
	(de.to_date = '9999-01-01')
	AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no ASC;

SELECT * FROM mentorship_eligibility;


-- Total roles to be filled
SELECT SUM(count) FROM retiring_titles;
SELECT COUNT(emp_no) FROM mentorship_eligibility;
SELECT COUNT(emp_no) FROM unique_titles;


-- Retrieve the number of mentorship eligible employees in each title
SELECT COUNT(title) AS "count", title
INTO mentorship_titles
FROM mentorship_eligibility
GROUP BY title
ORDER BY count DESC;

SELECT * FROM mentorship_titles;

-- How many employees will each mentor need to mentor to fill the holes
SELECT rt.title,
	rt.count AS "retiring count",
	mt.count AS "mentor count",
	ROUND((CAST(rt.count AS decimal)) / mt.count, 2) AS "mentees per mentor"
	--divide rt.count/mt.count
INTO mentees_per_mentor
FROM retiring_titles AS rt
LEFT OUTER JOIN mentorship_titles AS mt
ON (rt.title = mt.title);

SELECT * FROM mentees_per_mentor;







