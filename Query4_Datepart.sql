--Write a query to provide the date for nth occurence of sunday in future from given date
--datepart function give values for weekdays
--sunday -1
--monday-2
--saturday- 7
--sunday -- 1 7  = 8
--monday -- 2 6  = 8
--tuesday-- 3 5  = 8


declare @today_date date;
declare @n int;
set @today_date = '2022-01-03';--monday as weekday return 2
set @n = 3;

SELECT DATEADD(WEEk, @n-1,DATEADD(DAY, 8 - (DATEPART(WEEKDAY,@today_date)),@today_date))

