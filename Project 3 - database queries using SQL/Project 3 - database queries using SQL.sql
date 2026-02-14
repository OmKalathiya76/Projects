CREATE DATABASE sql_project;
USE sql_project;

CREATE TABLE emp (
  empno   INT(4) NOT NULL DEFAULT 0,
  ename   VARCHAR(10) NULL DEFAULT NULL,
  job     VARCHAR(9)  NULL DEFAULT NULL,
  mgr     INT(4)      NULL DEFAULT NULL,
  hiredate DATE       NULL DEFAULT NULL,
  sal     DECIMAL(7,2) NULL DEFAULT NULL,
  comm    DECIMAL(7,2) NULL DEFAULT NULL,
  deptno  INT(2)      NULL DEFAULT NULL,
  PRIMARY KEY (empno),
  KEY deptno (deptno)
);

CREATE TABLE dept (
  deptno INT NOT NULL,
  dname VARCHAR(14),
  loc VARCHAR(13),
  PRIMARY KEY (deptno)
);
ALTER TABLE emp
ADD CONSTRAINT fk_emp_dept
FOREIGN KEY (deptno) REFERENCES dept(deptno);

CREATE TABLE student (
  sid   INT PRIMARY KEY,
  sname VARCHAR(14),
  city  VARCHAR(20),
  marks INT
);

CREATE TABLE emp_log (
  log_id     INT AUTO_INCREMENT PRIMARY KEY,
  emp_id     INT,
  log_date   DATE,
  new_salary DECIMAL(7,2),
  action     VARCHAR(20)
);


INSERT INTO dept (deptno, dname, loc) VALUES
(10, 'ACCOUNTING', 'NEW YORK'),
(20, 'RESEARCH',   'DALLAS'),
(30, 'SALES',      'CHICAGO'),
(40, 'OPERATIONS', 'BOSTON');


INSERT INTO emp (empno, ename, job, mgr, hiredate, sal, comm, deptno) VALUES
(7369,'SMITH','CLERK',    7902,'1980-12-17', 800.00, NULL, 20),
(7499,'ALLEN','SALESMAN', 7698,'1981-02-20',1600.00, 300.00, 30),
(7521,'WARD','SALESMAN',  7698,'1981-02-22',1250.00, 500.00, 30),
(7566,'JONES','MANAGER',  7839,'1981-04-02',2975.00, NULL, 20),
(7654,'MARTIN','SALESMAN',7698,'1981-09-28',1250.00,1400.00, 30),
(7698,'BLAKE','MANAGER',  7839,'1981-05-01',2850.00, NULL, 30),
(7782,'CLARK','MANAGER',  7839,'1981-06-09',2450.00, NULL, 10),
(7788,'SCOTT','ANALYST',  7566,'1987-04-19',3000.00, NULL, 20),
(7839,'KING','PRESIDENT', NULL,'1981-11-17',5000.00, NULL, 10),
(7844,'TURNER','SALESMAN',7698,'1981-09-08',1500.00,   0.00, 30),
(7876,'ADAMS','CLERK',    7788,'1987-05-23',1100.00, NULL, 20),
(7900,'JAMES','CLERK',    7698,'1981-12-03', 950.00, NULL, 30),
(7902,'FORD','ANALYST',   7566,'1981-12-03',3000.00, NULL, 20),
(7934,'MILLER','CLERK',   7782,'1982-01-23',1300.00, NULL, 10);

INSERT INTO student (sid, sname, city, marks) VALUES
(1,'Amit','Delhi',78),
(2,'Riya','Surat',88),
(3,'Kishan','Rajkot',91),
(4,'Neha','Mumbai',67);

# 1
SELECT DISTINCT job FROM emp;

#2
SELECT * FROM emp ORDER BY deptno ASC, job DESC;

#3
SELECT DISTINCT job FROM emp ORDER BY job DESC;

#4
SELECT * FROM emp WHERE hiredate < '1981-01-01';

#5
SELECT empno, ename, sal,
       (sal/30) AS daily_sal,
       ((sal + IFNULL(comm,0))*12) AS annsal
FROM emp
ORDER BY annsal ASC;

#6
SELECT empno, ename, sal,
       TIMESTAMPDIFF(YEAR, hiredate, CURDATE()) AS exp_years
FROM emp
WHERE mgr = 7369;

#7
SELECT * FROM emp WHERE comm > sal;

#8
SELECT * FROM emp
WHERE job IN ('CLERK','ANALYST')
ORDER BY ename DESC;

#9
SELECT * FROM emp
WHERE ((sal + IFNULL(comm,0))*12) BETWEEN 22000 AND 45000;

#10
SELECT * FROM emp WHERE ename LIKE 'S____';

#11
SELECT * FROM emp
WHERE CAST(empno AS CHAR) NOT LIKE '78%';

#12
SELECT * FROM emp WHERE job='CLERK' AND deptno=20;

#13
SELECT e.*
FROM emp e
JOIN emp m ON e.mgr = m.empno
WHERE e.hiredate < m.hiredate;

#14
SELECT *
FROM emp
WHERE deptno = 20
  AND job IN (SELECT DISTINCT job FROM emp WHERE deptno = 10);

#15
SELECT *
FROM emp
WHERE sal IN (SELECT sal FROM emp WHERE ename IN ('FORD','SMITH'))
ORDER BY sal DESC;

#16
SELECT *
FROM emp
WHERE job IN (SELECT job FROM emp WHERE ename IN ('SMITH','ALLEN'));

#17
SELECT DISTINCT job
FROM emp
WHERE deptno = 10
  AND job NOT IN (SELECT DISTINCT job FROM emp WHERE deptno = 20);

#18
SELECT MAX(sal) AS highest_sal FROM emp;

#19
SELECT * FROM emp
WHERE sal = (SELECT MAX(sal) FROM emp);

#20
SELECT SUM(sal) AS total_manager_salary
FROM emp
WHERE job = 'MANAGER';

#21
SELECT * FROM emp WHERE ename LIKE '%A%';

#22
SELECT e.*
FROM emp e
JOIN (
  SELECT job, MIN(sal) AS min_sal
  FROM emp
  GROUP BY job
) x ON e.job = x.job AND e.sal = x.min_sal
ORDER BY e.job ASC;

#23
SELECT * FROM emp
WHERE sal > (SELECT sal FROM emp WHERE ename='BLAKE');

#24
CREATE OR REPLACE VIEW v1 AS
SELECT e.ename, e.job, d.dname, d.loc
FROM emp e
JOIN dept d ON e.deptno = d.deptno;

#25
DROP PROCEDURE IF EXISTS get_emp_dept;
DELIMITER $$

CREATE PROCEDURE get_emp_dept(IN p_dno INT)
BEGIN
  SELECT e.ename, d.dname
  FROM emp e
  JOIN dept d ON e.deptno = d.deptno
  WHERE e.deptno = p_dno;
END $$

DELIMITER ;

#26
ALTER TABLE student ADD pin BIGINT;

#27
ALTER TABLE student MODIFY sname VARCHAR(40);






