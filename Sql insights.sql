/* Creating new database */
create database credit;

/* Importing the table named credit_card_cleaned*/

select * from credit_cleaned;

/* Renaming the table */
RENAME TABLE credit_cleaned TO credit_card;



/*1.Group the customers based on their income type and find the average 
of their annual income.*/

select Type_income,round(avg(Annual_income),2) as Avg_income
from credit_card
group by Type_income
order by Avg_income desc;

/*Answer:
# Type_income	        Avg_income
Commercial associate	220539.04
State servant			206825.43
Working					178835.41
Pensioner				148199.26  */




# 2. Find the female owners of cars and property.
select count(Id) as Total_females
from credit_card
where Gender = 'F' and Car_owner = 'Y' and Property_owner ='Y';

/*# Answer:
Total_females
	179 			
179 Female customers own both Car and Property*/


#3.Find the male customers who are staying with their families.

select *
from credit_card
where Gender = 'M' and Family_members > 1;

/*Answer:
 470 males are living with their families */

#4.Please list the top five people having the highest income.

/* considering the top five income and people of this category */
with cte as (
select Id,Annual_income,rank() over (order by Annual_income desc) as rnk
from credit_card
order by Annual_income  desc)
select * from cte
where rnk <= 5;

/* Answer: 
1st Top income -492750- 3 persons- rank 1, (rank 2 and 3 is skipped)
2nd Top income - 450000- 1 person -rank 4
3rd Top income - 438750 -29 persons - rank 5

Id		Annual_income
5067653	492750
5088834	492750
5088836	492750
5009074	450000
5010864	438750....and 28 more */



#5.How many married people are having bad credit?
select count(Id) as Total
from credit_card
where Marital_status <> 'Single / not married'
and Credit_status = 1;

/*Answer:
	Total
	140
140 married people having bad credit */


#6.What is the highest education level and what is the total count?


select distinct Education from credit_card;
# Highest education level is "Academic degree"
/* # Education
Higher education
Secondary / secondary special
Lower secondary
Incomplete higher
Academic degree */



select count(Id) as Total 
from credit_card
where Education = 'Academic degree';

/* Answer:
	Total
	2
only 2 are of Highest education level */

#7.Between married males and females, who is having more bad credit?
with cte as (
select Gender, count(Id) as num_of_applicants,
sum(case when Credit_status = 1 then 1 else 0 end) bad_credit
from credit_card
where Marital_status <>  'Single / not married'
group by Gender)
select Gender ,round((bad_credit/num_of_applicants)*100,2) as percentage_bad_credit
from cte
order by percentage_bad_credit desc;

/* Answer: 
# Gender	percentage_bad_credit
	M			11.98
	F			9.80
# Males  have highest bad credit percentage (11.98%) */  

