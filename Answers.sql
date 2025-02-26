 select * from card_base
 select * from customer_base
 select * from fraud_base
 select * from transaction_base

1) How many customers have done transactions over 49000?

select count(*)
from transaction_base t
join card_base cb
on cb.card_number=t.credit_card_id
join customer_base c
on c.cust_id=cb.cust_id
where transaction_value > 49000

2) What kind of customers can get a Premium credit card?

select distinct customer_segment
from customer_base cb
join card_base c
on c.cust_id=cb.cust_id
where card_family = 'Premium'

3)Identify the range of credit limit of customer who have done fraudulent 
transactions.

select concat(min(credit_limit),' - ',max(credit_limit)) as credit_range
from card_base cb
join transaction_base tb
on cb.card_number = tb.credit_card_id
join fraud_base fb
on fb.transaction_id=tb.transaction_id

4)What is the average age of customers who are involved in fraud transactions 
based on different card type

select card_family,round(avg(age),2) as avg_age
from customer_base c
join card_base cb
on cb.cust_id=c.cust_id
join transaction_base tb
on cb.card_number=tb.credit_card_id
join fraud_base fb
on fb.transaction_id=tb.transaction_id
group by 1

5)  Identify the month when highest no of fraudulent transactions occured

select extract(month from transaction_date) as months,count(*) as no_of_fraudulent_transactions
from transaction_base tb
join fraud_base fb
on tb.transaction_id=fb.transaction_id
group by extract(month from transaction_date)
order by 2 desc
limit 1

6)Identify the customer who has done the most transaction value without 
involving in any fraudulent transactions

 select c.cust_id, sum(tb.transaction_value) as total_value
 from customer_base c
 join card_base cb
 on c.cust_id=cb.cust_id
 join transaction_base tb
 on tb.credit_card_id= cb.card_number
 where c.cust_id not in (select cb.cust_id 
						from card_base cb
                        join transaction_base tb
                        on tb.credit_card_id= cb.card_number
                        join fraud_base fb on fb.transaction_id=tb.transaction_id)
 group by c.cust_id
 order by 2 desc
limit 1


7) Check and return any customers who have not done a single transaction.

 select distinct c.cust_id from customer_base c
 where c.cust_id not in (select cb.cust_id from card_base cb
                         join transaction_base tb
						  on tb.credit_card_id=cb.card_number)
						 
 
8) What is the highest and lowest credit limit given to each card type?

select card_family,min(credit_limit) as low_credit,max(credit_limit) as high_credit
from card_base
group by 1

9) What is the total value of transactions done by customers who come under the age bracket of  
0-20 yrs, 20-30 yrs, 30-40 yrs, 40-50 yrs, 50+ yrs

select sum(case when age > 0 and age <= 20 then transaction_value else 0 end) as trns_value_0_to_20
	, sum(case when age > 20 and age <= 30 then transaction_value else 0 end) as trns_value_20_to_30
	, sum(case when age > 30 and age <= 40 then transaction_value else 0 end) as trns_value_30_to_40
	, sum(case when age > 40 and age <= 50 then transaction_value else 0 end) as trns_value_40_to_50
	, sum(case when age > 50 then transaction_value else 0 end) as trns_value_greater_than_50
	from Transaction_base trn
	join Card_base crd on trn.credit_card_id = crd.card_number
	join customer_base cst on cst.cust_id=crd.cust_id


10) Which card type has done the most no of transactions 
and the total highest value of transactions without having any fraudulent transactions.


 select * from card_base
 select * from customer_base
 select * from fraud_base
 select * from transaction_base

(select cb.card_family,count(*) as highest_no_of_transactions
from card_base cb
join transaction_base tb
on cb.card_number=tb.credit_card_id
where cb.card_family not in (select distinct cb.card_family from card_base cb
join transaction_base tb
on cb.card_number=tb.credit_card_id
join fraud_base fb on fb.transaction_id=tb.transaction_id)
group by 1
order by 2 desc
limit 1)
union all
(select cb.card_family,sum(tb.transaction_value) as highest_no_of_transactions
from card_base cb
join transaction_base tb
on cb.card_number=tb.credit_card_id
where cb.card_family not in (select distinct cb.card_family from card_base cb
join transaction_base tb
on cb.card_number=tb.credit_card_id
join fraud_base fb on fb.transaction_id=tb.transaction_id)
group by 1
order by 2 desc
limit 1)
