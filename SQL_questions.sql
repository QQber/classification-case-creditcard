# 4. Select all the data from table credit_card_data to check if the data was imported correctly.
select*from credit_card_data;

# 5. Use the alter table command to drop the column q4_balance from the database, as we would not use it in the analysis with SQL. Select all the data from the table to verify if the command worked. Limit your returned results to 10.
alter table credit_card_data drop q4_balance;
select*from credit_card_data
limit 10;

# 6. Use sql query to find how many rows of data you have.
select count(customer_number) from credit_card_data;

# 7. Now we will try to find the unique values in some of the categorical columns:
# 7.1 What are the unique values in the column Offer_accepted?
select distinct offer_accepted from credit_card_data;

# 7.2 What are the unique values in the column Reward?
select distinct reward from credit_card_data;

# 7.3 What are the unique values in the column mailer_type?
select distinct mailer_type from credit_card_data;

# 7.4 What are the unique values in the column credit_cards_held?
select distinct num_credit_cards_held from credit_card_data;

# 7.5 What are the unique values in the column household_size?
select distinct household_size from credit_card_data;

# 8. Arrange the data in a decreasing order by the average_balance of the house. Return only the customer_number of the top 10 customers with the highest average_balances in your data.
select customer_number from credit_card_data
order by Average_Balance desc
limit 10;

# 9. What is the average balance of all the customers in your data?
select avg(average_balance) from credit_card_data;

# 10. In this exercise we will use simple group by to check the properties of some of the categorical variables in our data. Note wherever average_balance is asked, please take the average of the column average_balance:
# 10.1 What is the average balance of the customers grouped by Income Level? The returned result should have only two columns, income level and Average balance of the customers. Use an alias to change the name of the second column.
select income_level, avg(average_balance) as 'Average balance' from credit_card_data
group by income_level;

# 10.2 What is the average balance of the customers grouped by number_of_bank_accounts_open? The returned result should have only two columns, number_of_bank_accounts_open and Average balance of the customers. Use an alias to change the name of the second column.
select Num_Bank_Accounts_Open as number_of_bank_accounts_open, avg(average_balance) as 'Average balance' from credit_card_data
group by Num_Bank_Accounts_Open;

# 10.3 What is the average number of credit cards held by customers for each of the credit card ratings? The returned result should have only two columns, rating and average number of credit cards held. Use an alias to change the name of the second column.
select credit_rating as rating, avg(Num_Credit_Cards_Held) as 'average number of credit cards held' from credit_card_data
group by credit_rating;

# 10.4 Is there any correlation between the columns credit_cards_held and number_of_bank_accounts_open? You can analyse this by grouping the data by one of the variables and then aggregating the results of the other column. Visually check if there is a positive correlation or negative correlation or no correlation between the variables.
select count(Num_Credit_Cards_Held) as credit_cards, Num_Bank_Accounts_Open from credit_card_data
group by Num_Bank_Accounts_Open; # negative correlation
select count(Num_Bank_Accounts_Open) as bank_account, Num_Credit_Cards_Held from credit_card_data
group by Num_Credit_Cards_Held
order by Num_Credit_Cards_Held; # negative correlation

# 11. Your managers are only interested in the customers with the following properties:
# 11.1 Credit rating medium or high
select customer_number from credit_card_data
where credit_rating = 'medium' or credit_rating = 'high';

# 11.2 Credit cards held 2 or less
select customer_number from credit_card_data
where Num_Credit_Cards_Held <= 2;

# 11.3 Owns their own home
select customer_number from credit_card_data
where Own_Your_Home = 'yes';

# 11.4 Household size 3 or more
select customer_number from credit_card_data
where Household_Size >=3;

# For the rest of the things, they are not too concerned. Write a simple query to find what are the options available for them? Can you filter the customers who accepted the offers here?
select customer_number from credit_card_data
where Income_Level = 'medium' or Income_Level = 'high' and Overdraft_Protection ='yes'and Offer_Accepted='yes';

# 12. Your managers want to find out the list of customers whose average balance is less than the average balance of all the customers in the database. Write a query to show them the list of such customers. You might need to use a subquery for this problem.
select Customer_Number from credit_card_data
where Average_Balance >
(select avg(Average_Balance) from credit_card_data
);

# 13. Since this is something that the senior management is regularly interested in, create a view of the same query.
create view avg_balance as
select Customer_Number from credit_card_data
where Average_Balance >
(select avg(Average_Balance) from credit_card_data
);

# 14. What is the number of people who accepted the offer vs number of people who did not?
select count(Customer_Number), Offer_Accepted from credit_card_data
group by Offer_Accepted;

# 15. Your managers are more interested in customers with a credit rating of high or medium. What is the difference in average balances of the customers with high credit card rating and low credit card rating?
select avg(Average_Balance) as high_avg, Credit_Rating from credit_card_data
where Credit_Rating ='high' or Credit_Rating='low'
group by Credit_Rating;

# 16. In the database, which all types of communication (mailer_type) were used and with how many customers?
select count(Customer_Number),Mailer_Type from credit_card_data
group by Mailer_Type;

# 17. Provide the details of the customer that is the 11th least Q1_balance in your database.
select * from
(select (@rowno:=@rowno+1) as rowno,	
		Customer_Number,	
		Offer_Accepted,Reward,	
        Mailer_Type,Income_Level,	
        Num_Bank_Accounts_Open,	
        Overdraft_Protection,	
        Credit_Rating,	
        Num_Credit_Cards_Held,	
        Num_Homes_Owned,	
        Household_Size,	
        Own_Your_Home 	
from credit_card_data,
(select (@rowno:=0)) b
order by Q1_Balance)c
where rowno =11; # this is not consider same values

select*from
(select	Customer_Number,	
		Offer_Accepted,Reward,	
        Mailer_Type,Income_Level,	
        Num_Bank_Accounts_Open,	
        Overdraft_Protection,	
        Credit_Rating,	
        Num_Credit_Cards_Held,	
        Num_Homes_Owned,	
        Household_Size,	
        Own_Your_Home,	
        dense_rank() over (order by Q1_Balance asc) as position
from credit_card_data)t
where position =11; # considered same values