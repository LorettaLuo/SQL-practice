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

#196 delete duplicate emails 
DELETE p1
FROM person p1, person p2
WHERE p1.email = p2.email AND p1.id>P2.id
#需要后续再看一遍

#595 big countries
SELECT name, population, area
FROM world
WHERE area > 3000000 OR population >25000000;

597 friend request2 1: overall acceptance rate 
SELECT if
FROM 
WHERE r.sender_id = r.requester_id ADN 
#需要后续再看一遍




IFNULL(expr1,expr2)
#如果 expr1 不是 NULL，IFNULL() 返回 expr1，否则它返回 expr2。IFNULL() 返回一个数字或字符串值，取决于它被使用的上下文环境
