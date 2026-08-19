select count(*) from credit_risk_dataset;

create table clean_credit_data AS 
select * from credit_risk_dataset
where person_age <100
AND person_emp_length<50
AND person_emp_length IS NOT NULL
AND loan_int_rate IS NOT NULL;

select count(*) from clean_credit_data;

select loan_intent, count(*) as total_loans,sum(loan_status) as total_defaulters
from clean_credit_data group by loan_intent
order by total_defaulters desc;

select loan_status , count(*) as total_people, round(avg(person_income),0) as average_income,
round(avg(person_age),0) as average_age
from clean_credit_data
group by loan_status;

-- 1. KPI
select
	count(*) as total_loans_given,
	sum(case when loan_status=1 then loan_amnt else 0 end) as total_money_lost,
	round((sum(loan_status)/count(*))*100,2) as overall_default_rate_percentage
from clean_credit_data;

-- 2. DEMOGRAPHIC RISK ANALYSIS
select
	person_home_ownership,
	count(*) as total_customers,
	sum(loan_status) as total_defaulters,
	round((sum(loan_status)/count(*))*100,2) as default_percentage
from clean_credit_data
group by person_home_ownership
order by default_percentage desc;

-- 3. PURPOSE BASED RISK
select 
	loan_intent,
    count(*) as total_loans,
    round((sum(loan_status)/count(*))*100,2) as default_percentage
from clean_credit_data
group by loan_intent
order by default_percentage desc;

-- 4. FINANCIAL HEALTH(LOAN TO INCOME RATIO)
select 
	loan_status,
    round(avg(loan_percent_income)*100,2) as avg_loan_to_income_percentage
from clean_credit_data
group by loan_status;

-- 5. BANK'S GRADING SYSTEM CHECK
select
    loan_grade,
    count(*) as total_loans,
    round((sum(loan_status)/count(*))*100,2) as default_percentage
from clean_credit_data
group by loan_grade
order by loan_grade;

-- 6. HISTORICAL IMPACT
select
    cb_person_default_on_file as prior_default_history,
    count(*) as total_customers,
    round((sum(loan_status)/count(*))*100,2) as current_default_percentage
from clean_credit_data
group by cb_person_default_on_file;

describe clean_credit_data;