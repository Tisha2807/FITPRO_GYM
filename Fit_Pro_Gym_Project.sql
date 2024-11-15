-- Setup FitPro Database Schemas
-- Drop tables if they exist
DROP TABLE IF EXISTS visits, memberships, members;

-- Create members table
CREATE TABLE members (
    member_id INT PRIMARY KEY,
    name VARCHAR(100)
);

-- Create memberships table
CREATE TABLE memberships (
    member_id INT PRIMARY KEY,
    age INT,
    gender CHAR(1),
    membership_type VARCHAR(20),
    join_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- Create visits table
CREATE TABLE visits (
    visit_id INT PRIMARY KEY,
    member_id INT,
    visit_date DATE,
    check_in_time TIME,
    check_out_time TIME,
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

SELECT 'All table created succussful!';
-- Schemas Creation END

--1.Retrieve the name and membership_type of members who are female (gender = 'F').

SELECT m.name, ms.membership_type 
from members m 
join memberships ms
on m.member_id=ms.member_id 
where gender='F';

--2.Find all members who have a Monthly membership type and have joined after 2023-11-01.

SELECT * 
     FROM members M 
	 JOIN memberships MS
	 ON M.member_id=MS.MEMBER_ID
	 JOIN VISITS V
	 ON V.member_id = M.member_id
	 WHERE MS.MEMBERSHIP_TYPE = 'Monthly' AND MS.join_date >= '2023-11-01';
	 
--3.Retrieve the name and status of members who have an Active status and are aged above 25.
SELECT m.name, ms.status
FROM members AS m
INNER JOIN 
    memberships AS ms
ON  m.member_id = ms.member_id
WHERE ms.status = 'Active' AND ms.age > 25;

--4.Retrieve the details of visits made by members with visit_date = '2024-01-01'.
SELECT * FROM members M
JOIN 
memberships MS 
ON M.member_id = MS.member_id
JOIN 
VISITS V
ON M.member_id = V.member_id
WHERE V.visit_date='2024-01-01';

--5.Get the list of members who have a Quarterly membership type and are aged between 20 and 30.

SELECT * 
FROM members M
JOIN 
memberships MS 
ON M.member_id = MS.member_id
WHERE 
MS.MEMBERSHIP_TYPE = 'Quaterly' AND MS.AGE BETWEEN 20 AND 30;

-- 6.Find the total number of visits made by each member, grouping by member_id.
SELECT member_id,count(visit_date) as total_number_of_vists
from visits 
group by member_id;

--7.Retrieve the count of members by membership_type (e.g., how many Monthly, Weekly, and Quarterly members there are)
select membership_type,
       count(membership_type) AS count_of_membershp_type
from memberships 
group by membership_type;

--8.Get the average age of members, grouped by their membership_type.

SELECT membership_type,
       ROUND(AVG(age)) AS average_age
FROM memberships
GROUP BY membership_type;

--9.Find the total number of visits for each visit_date (group by the visit date).
select visit_date,
       count(visit_date) as count_of_visit_date
from visits 
group by visit_date;
	   
--10.Retrieve the number of members with each status (Active or Cancelled), grouped by status.

SELECT 
    status, 
    COUNT(member_id) AS member_count
FROM  memberships
WHERE status IN ('Active', 'Cancelled')
GROUP BY status;

--11.Retrieve the top 3 members who have made the most visits, only showing name and total_visits, 
-- and order by total_visits in descending order.

SELECT M.NAME,COUNT(V.VISIT_DATE) AS total_visits
FROM MEMBERS M 
JOIN VISITS V
ON M.member_id = V.member_id
GROUP BY M.NAME 
ORDER  BY total_visits DESC
LIMIT 3;

--12.Find the number of members with a Monthly membership who are Active, 
--grouped by membership_type, and limit the result to the top 2 most recent join dates.

SELECT 
    membership_type, 
    join_date, 
    COUNT(member_id) AS member_count
FROM memberships
GROUP BY membership_type, join_date
HAVING membership_type = 'Monthly'
ORDER BY join_date DESC
LIMIT 2;

--13.Get the total number of visits for each member who has more than 2 visits, 
--ordered by total_visits, and display only the first 5 members.
select member_id,count(visit_date) as total_visits
from visits 
group by member_id
having count(visit_date) > 2
order by total_visits
limit 5;

--14.Retrieve the number of members who have joined in 2023, 
--grouped by membership_type, where the total number of members in each group is more than 1.

SELECT membership_type,COUNT(MEMBER_ID)
FROM MEMBERSHIPS 
WHERE EXTRACT(YEAR FROM JOIN_DATE)= 2023
GROUP BY membership_type
HAVING COUNT(MEMBER_ID) > 1

--15.Find the average age of members who have Active membership status, 
-- grouped by membership_type, ordered by membership_type alphabetically, and limit the result to 3.

SELECT membership_type,ROUND(AVG(AGE)) AS AVG_AGE
FROM MEMBERSHIPS 
WHERE STATUS='Active'
group by membership_type
order by membership_type ASC
LIMIT 3;
