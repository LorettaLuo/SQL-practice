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
           
#3) 
