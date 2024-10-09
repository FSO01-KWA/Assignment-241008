-- 1
SELECT s.name, c.course_name
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id
INNER JOIN courses c ON e.course_id = c.course_id;

-- 2
SELECT e.name, COALESCE(d.dept_name, 'None') AS dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id;

-- 3
SELECT s.supplier_name, COALESCE(p.product_name, 'No Product') AS product_name
FROM suppliers s
RIGHT JOIN products p ON s.supplier_id = p.supplier_id;

-- 4
SELECT s.name, COALESCE(c.club_name, NULL) AS club_name
FROM students s
FULL OUTER JOIN club_memberships cm ON s.student_id = cm.student_id
FULL OUTER JOIN clubs c ON cm.club_id = c.club_id;

-- 5
SELECT e1.name AS employee_name, COALESCE(e2.name, 'No Manager') AS manager_name
FROM employees e1
LEFT JOIN employees e2 ON e1.manager_id = e2.employee_id;

-- 6
SELECT region, SUM(amount) AS total_sales
FROM sales
GROUP BY region
HAVING SUM(amount) >= 100000;

-- 7
SELECT product_name, price
FROM products
ORDER BY price DESC
LIMIT 5;

-- 8
SELECT customer_id, COUNT(order_id) AS order_count
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) >= 5;

-- 9
SELECT department, SUM(salary) AS total_salary, AVG(salary) AS average_salary
FROM employees
GROUP BY department;

-- 10
SELECT product_name, price
FROM products
WHERE price = (SELECT MAX(price) FROM products)
OR price = (SELECT MIN(price) FROM products);

-- 11
SELECT name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- 12
SELECT c.customer_id, c.name
FROM customers c
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id);

-- 13
SELECT name
FROM current_students
UNION
SELECT name
FROM alumni;

-- 14
SELECT c.name
FROM customers c
INTERSECT
SELECT s.customer_id
FROM subscribers s;

-- 15
SELECT name
FROM students
EXCEPT
SELECT name
FROM graduates;

-- 16
WITH DepartmentSalaries AS (
    SELECT department, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department
)
SELECT e.name, e.department, e.salary
FROM employees e
JOIN DepartmentSalaries ds ON e.department = ds.department
WHERE e.salary < ds.avg_salary;

-- 17
WITH RECURSIVE CategoryHierarchy AS (
    SELECT category_id, category_name, parent_id
    FROM categories
    WHERE parent_id IS NULL
    UNION ALL
    SELECT c.category_id, c.category_name, c.parent_id
    FROM categories c
    JOIN CategoryHierarchy ch ON c.parent_id = ch.category_id
)
SELECT * FROM CategoryHierarchy;

-- 18
SELECT salesperson_id, SUM(amount) AS total_sales,
       RANK() OVER (ORDER BY SUM(amount) DESC) AS sales_rank
FROM sales
GROUP BY salesperson_id;

-- 19
BEGIN;
UPDATE accounts
SET balance = balance - 500
WHERE account_id = 1;
UPDATE accounts
SET balance = balance + 500
WHERE account_id = 2;
COMMIT;

-- 20
CREATE INDEX idx_department_hire_date ON employees (department, hire_date);
SELECT name, hire_date
FROM employees
WHERE department = 'target_department'
ORDER BY hire_date DESC
LIMIT 10;
