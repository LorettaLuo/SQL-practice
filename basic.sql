#175 combine 2 tables
SELECT p.FirstName, p.lastname, a.city, a.state
FROM Person p
LEFT JOIN Address a
  ON p.personid = a.personid;
#remember to use left join, right join, inner join

#176 second highest salary
SELECT MAX(salary) AS SecondHighestSalary
FROM employee
WHERE salary< (SELECT MAX(salary) FROM employee);
#delete the highest & choose the highest

#181 emplpyees earning more than their managers 
SELECT a.name 
FROM employee a, employee b
WHERE a.managerid = 'NULL' AND 
      a.salary >b.salary AND a.managerid=b.id
#???? a.managerid=b.id 代表啥没搞懂

#182 duplicate emails
SELECT email
FROM person
GROUP BY email
HAVING count(*)>1;

#183 customers who never order
SELECT c.name AS customers
FROM customers c
LEFT JOIN orders o
  ON c.id = o.customerid
WHERE o.customerid IS NULL;

#196 delete duplicate emails 
DELETE p1
FROM person p1, person p2
WHERE p1.email = p2.email AND p1.id>P2.id
#需要后续再看一遍

#197 rising temperature
SELECT a.id 
FROM weather a, weather b
WHERE a.recorddate-b.recorddate=1 AND
      a.temperature>b.temperature
#也可以写成a INNER JOIN b, WHERE DATEDIFF(a.data, b.date)=1 ADN...

#577 employee bonus 


#595 big countries
SELECT name, population, area
FROM world
WHERE area > 3000000 OR population >25000000;

597 friend request2 1: overall acceptance rate 
SELECT ifnull(round(count(DISTINCT requester_id, accepter_id)/count(DISTINCT sender_id, send_to_id),2),0) as accept rate
FROM reuqest_accepted, friend_request
#?????需要后续再看一遍

610 triangle judgement 
SELECT x,y,z
CASE WHEN x+y>z OR 
          x+z>y OR 
          y+z>x
     THEN 'Yes'
     ELSE 'No'
END AS 'triangle'
FROM triangle 
#CASE WHEN的例子，要记得重命名一个column用end as


IFNULL(expr1,expr2)
#如果 expr1 不是 NULL，IFNULL() 返回 expr1，否则它返回 expr2。IFNULL() 返回一个数字或字符串值，取决于它被使用的上下文环境
