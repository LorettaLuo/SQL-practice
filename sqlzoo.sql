#This is for SQL practice, where recording all my answers in case of future improvement. 
#4. SELECT within SELECT Tutorial
#1) List each country name where the population is larger than that of 'Russia'.
SELECT name FROM world
  WHERE population >
     (SELECT population FROM world
      WHERE name='Russia')
      
#2) Show the countries in Europe with a per capita GDP greater than 'United Kingdom'.
SELECT name FROM world
WHERE gdp/population >
   (SELECT gdp/population FROM world 
    WHERE name='United Kingdom') AND continent = 'Europe'

#3) List the name and continent of countries in the continents containing either Argentina or Australia. Order by name of the country.
SELECT name, continent
FROM world 
WHERE continent IN
   (SELECT continent FROM world 
    WHERE name ='Argentina' OR name ='Australia')
ORDER BY name

#4) Which country has a population that is more than Canada but less than Poland? Show the name and the population.
SELECT name, population
FROM world 
WHERE population >
   (SELECT population FROM world
    WHERE name ='Canada') AND population <
   (SELECT population FROM world
    WHERE name ='Poland')

#5)Show the name and the population of each country in Europe. Show the population as a percentage of the population of Germany.
SELECT name
  FROM world
 WHERE population >= ALL(SELECT population
                           FROM world
                          WHERE population>0)
                       
#6)Which countries have a GDP greater than every country in Europe? [Give the name only.] (Some countries may have NULL gdp values)
SELECT name
FROM world
WHERE gdp > ALL(SELECT gdp FROM world
   WHERE continent = 'Europe' AND gdp>0)
   
#7)Find the largest country (by area) in each continent, show the continent, the name and the area
SELECT continent, name, area 
FROM world x
WHERE x.area >= ALL
    (SELECT y.area FROM world y
     WHERE y.continent=x.continent
     AND area>0)
     
#8)List each continent and the name of the country that comes first alphabetically.
SELECT continent,name
FROM world x
WHERE x.name = (SELECT TOP 1 y.name FROM world y
   WHERE x.continent = y.continent ORDER BY name)

#9)Find the continents where all countries have a population <= 25000000. Then find the names of the countries associated with these continents. Show name, continent and population.
SELECT name,continent,population 
FROM world x 
WHERE 25000000 >=all(SELECT y.population FROM world y 
   WHERE x.continent=y.continent AND population>0)
   
#10)
SELECT name, continent
FROM world x
WHERE x.population >= ALL(SELECT y.population*3 FROM world y
   WHERE x.continent = y.continent AND x.name !=y.name AND population>0)









# More JOIN operations
#06) Obtain the cast list for 'Casablanca'.
SELECT name
FROM actor
JOIN casting ON (id=actorid)
WHERE movieid=27

#07) Obtain the cast list for the film 'Alien'
SELECT a.name
FROM actor a
JOIN casting c ON a.id=c.actorid
JOIN movie m ON c.movieid=m.id
WHERE m.title = 'Alien'

#08) List the films in which 'Harrison Ford' has appeared
SELECT m.title
FROM movie m
JOIN casting c ON c.movieid=m.id
JOIN actor a ON a.id=c.actorid
WHERE name = 'Harrison Ford'

#09) List the films where 'Harrison Ford' has appeared - but not in the starring role.
SELECT m.title
FROM movie m
JOIN casting c ON c.movieid=m.id
JOIN actor a ON a.id=c.actorid
WHERE name = 'Harrison Ford' AND c.ord<>1

#10) List the films together with the leading star for all 1962 films.
SELECT m.title, a.name
FROM movie m
JOIN casting c ON c.movieid=m.id
JOIN actor a ON a.id=c.actorid
WHERE m.yr=1962 AND c.ord=1

#11) Which were the busiest years for 'Rock Hudson', show the year and the number of movies he made each year for any year in which he made more than 2 movies.
SELECT yr,COUNT(title) FROM
  movie JOIN casting ON movie.id=movieid
        JOIN actor   ON actorid=actor.id
WHERE name='Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2

#12) List the film title and the leading actor for all of the films 'Julie Andrews' played in.
SELECT title, name
FROM movie JOIN casting ON (movieid=movie.id
                            AND ord=1)
           JOIN actor ON (actorid=actor.id)
WHERE movie.id IN(
  SELECT movieid FROM casting
  WHERE actorid IN (
    SELECT id FROM actor
    WHERE name='Julie Andrews')
  )

#13) Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles.
SELECT name FROM actor
JOIN casting ON actorid=actor.id
WHERE ord=1
GROUP BY actor.name
HAVING COUNT(ord)>=15

#14) List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
SELECT title, COUNT(actorid)
FROM movie
JOIN casting ON (movie.id=movieid)
WHERE yr = 1978
GROUP BY title
ORDER BY COUNT(actorid) DESC, title

# 15) List all the people who have worked with 'Art Garfunkel'.
SELECT DISTINCT name
FROM actor
JOIN casting ON (actor.id=actorid)
JOIN movie ON (movieid=movie.id)
WHERE movieid IN
   (SELECT movieid FROM casting
   JOIN movie ON (movie.id=movieid)
   JOIN actor ON (actor.id =actorid)
   WHERE name='Art Garfunkel')
      AND name <> 'Art Garfunkel'
   






#Using Null
#1) List the teachers who have NULL for their department.
SELECT teacher.name FROM teacher
WHERE dept IS NULL

#2) Note the INNER JOIN misses the teachers with no department and the departments with no teacher.
SELECT teacher.name, dept.name
 FROM teacher INNER JOIN dept
           ON (teacher.dept=dept.id)
           
#3) Use a different JOIN so that all teachers are listed.
SELECT teacher.name, dept.name
 FROM teacher LEFT JOIN dept
           ON (teacher.dept=dept.id)
           
#4) Use a different JOIN so that all departments are listed.
SELECT teacher.name, dept.name
 FROM teacher RIGHT JOIN dept
           ON (teacher.dept=dept.id)
           
#5) Use COALESCE to print the mobile number. Use the number '07986 444 2266' if there is no number given. Show teacher name and mobile number or '07986 444 2266'
SELECT name, COALESCE(mobile, '07986 444 2266')FROM teacher

#6) Use the COALESCE function and a LEFT JOIN to print the teacher name and department name. Use the string 'None' where there is no department.
SELECT t.name, COALESCE(dept.name, 'None')
FROM teacher t
LEFT JOIN dept ON (dept=dept.id)

#7) Use COUNT to show the number of teachers and the number of mobile phones.
SELECT COUNT(name), COUNT(mobile)
FROM teacher

#8) Use COUNT and GROUP BY dept.name to show each department and the number of staff. Use a RIGHT JOIN to ensure that the Engineering department is listed.
SELECT dept.name, COUNT(teacher.name)
FROM dept
LEFT JOIN teacher ON (dept.id=teacher.dept)
GROUP BY dept.name

#9) Use CASE to show the name of each teacher followed by 'Sci' if the teacher is in dept 1 or 2 and 'Art' otherwise.
SELECT name, CASE WHEN dept=1 OR dept=2 THEN 'Sci' 
             ELSE 'Art' END
FROM teacher 

#10) Use CASE to show the name of each teacher followed by 'Sci' if the teacher is in dept 1 or 2, show 'Art' if the teacher's dept is 3 and 'None' otherwise.
SELECT name, CASE WHEN dept=1 OR dept=2 THEN 'Sci' 
             WHEN dept=3 THEN 'Art' 
             ELSE 'None' END
FROM teacher 








#Self join
#1) How many stops are in the database.
SELECT COUNT(*)
FROM stops

#2) Find the id value for the stop 'Craiglockhart'
SELECT id
FROM stops
WHERE name='Craiglockhart'

#3) Give the id and the name for the stops on the '4' 'LRT' service.
SELECT id, name FROM stops, route
WHERE id=stop
AND company='LRT'
AND num='4'

#4) The query shown gives the number of routes that visit either London Road (149) or Craiglockhart (53). Run the query and notice the two services that link these stops have a count of 2. Add a HAVING clause to restrict the output to these two routes.
SELECT company, num, COUNT(*)
FROM route WHERE stop=149 OR stop=53
GROUP BY company, num
HAVING COUNT(*) = 2

#5) Execute the self join shown and observe that b.stop gives all the places you can get to from Craiglockhart, without changing routes. Change the query so that it shows the services from Craiglockhart to London Road.
SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop=53 AND b.stop =149

#6) The query shown is similar to the previous one, however by joining two copies of the stops table we can refer to stops by name rather than by number. Change the query so that the services between 'Craiglockhart' and 'London Road' are shown. If you are tired of these places try 'Fairmilehead' against 'Tollcross'
SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' AND stopb.name='London Road'

#7) Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')
SELECT DISTINCT a.company, a.num
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop=115 AND b.stop =137

#8) Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'
SELECT DISTINCT a.company, a.num
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop=(SELECT id FROM stops 
              WHERE name ='Craiglockhart')
AND b.stop =(SELECT id FROM stops 
              WHERE name ='Tollcross')

#9) Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, including 'Craiglockhart' itself, offered by the LRT company. Include the company and bus no. of the relevant services.
SELECT DISTINCT(s1.name),r1.company,r1.num 
FROM stops s1,stops s2,route r1,route r2
WHERE s2.id=r2.stop
AND  s2.name='Craiglockhart'
AND  r2.company=r1.company
AND  r2.num=r1.num
AND  r1.stop=s1.id;

#10) Find the routes involving two buses that can go from Craiglockhart to Lochend.
#Show the bus no. and company for the first bus, the name of the stop for the transfer,
#and the bus no. and company for the second bus.
SELECT distinct  a.num,a.company, stopb.name,  second.num, second.company
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
  JOIN 
(
SELECT distinct  stopaa.name, aa.num, aa.company
FROM route aa JOIN route bb ON
  (aa.company=bb.company AND aa.num=bb.num)
  JOIN stops stopaa ON (aa.stop=stopaa.id)
  JOIN stops stopbb ON (bb.stop=stopbb.id)
  where stopbb.name ='Lochend'
) second on stopb.name = second.name
WHERE stopa.name='Craiglockhart'






#Numeric Examples
#6) Show the percentage of students who A_STRONGLY_AGREE to question 22 for the subject '(8) Computer Science' show the same figure for the subject '(H) Creative Arts and Design'.
SELECT subject, 
ROUND(SUM(response*A_STRONGLY_AGREE)/SUM(response),0)
  FROM nss
 WHERE question='Q22'
   AND subject='(H) Creative Arts and Design'
   OR subject='(8) Computer Science'
GROUP BY subject
  
#7) Show the average scores for question 'Q22' for each institution that include 'Manchester' in the name.
SELECT institution, ROUND(SUM(response*score)/SUM(response),0)
FROM nss
WHERE question='Q22'
AND (institution LIKE '%Manchester%')
GROUP BY institution
ORDER BY institution

#8) Show the institution, the total sample size and the number of computing students for institutions in Manchester for 'Q01'.
SELECT institution,SUM(sample), 
  (SELECT sample FROM nss y
   WHERE subject='(8) Computer Science'
   AND x.institution = y.institution
   AND question='Q01') AS comp
FROM nss x
WHERE question='Q01'
AND (institution LIKE '%Manchester%')
GROUP BY institution







#Window function
#1) Show the lastName, party and votes for the constituency 'S14000024' in 2017.







