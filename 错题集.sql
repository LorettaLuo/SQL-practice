1. 在''里还有'怎么办？用''即可
eg: WHERE winner = 'Neill O''Chile'

2. concat()函数的用法
-->将多个字符串连接成一个字符串。
-->语法：concat(str1, str2,...)　

3. round的时候写着0，但是小数点后全是0，解决这个问题用：
   CAST(ROUND(11.6,0) as int)
   
4. use the word ALL to allow >= or > or < or <=to act over a list
SELECT name
FROM world
WHERE population >= ALL(SELECT population
                        FROM world
                        WHERE population>0)
                        
5. SELECT TOP 1 * <=> SELECT * ...LIMIT 1

6.COALESCE 用法：按顺序选择不是NULL的那个 
  COALESCE(x,y,z) = x if x is not NULL
  COALESCE(x,y,z) = y if x is NULL and y is not NULL
  COALESCE(x,y,z) = z if x and y are NULL but z is not NULL
  COALESCE(x,y,z) = NULL if x and y and z are all NULL
