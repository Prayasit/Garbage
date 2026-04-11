create table agents(
agent_id serial primary key,
first_name varchar,
last_name varchar,
contact_number bigint,
email varchar,
commission_rate real
)
copy agents from 'C:\mock\Agents.csv' delimiter ',' csv header 


create table customers(
customer_id serial primary key,
first_name varchar,
last_name varchar,
date_of_birth date,
gender varchar,
contact_number bigint,
email varchar,
address varchar,
aadhaar_number bigint,
pan_number varchar
)
copy customers from 'C:\mock\Customers.csv' delimiter ',' csv header 


create table policies(
Policy_Id serial primary key, 
policy_type varchar,
coverage_amount int,
premium_amount int,
start_date date,
end_date date,
customer_id int REFERENCES customers(customer_id),
agent_id int REFERENCES agents(agent_id),
approved_by varchar
)
copy policies from 'C:\mock\Policies.csv' delimiter ',' csv header 


create table claims(
claim_id serial primary key,
claim_date date,
amount_claimed int,
status varchar,
policy_id int REFERENCES policies(Policy_Id),
approved_by varchar
)
copy claims from 'C:\mock\claims.csv' delimiter ',' csv header 


create table payments(
payment_uuid varchar PRIMARY key,
payment_date date,
amount int,
payment_method varchar,
policy_id int REFERENCES policies(Policy_Id)
)
copy payments from 'C:\mock\payments.csv' delimiter ',' csv header 


SELECT c.first_name,COUNT(p.policy_id) AS total_policies FROM customers c
LEFT JOIN policies p ON c.customer_id = p.customer_id GROUP BY c.first_name;


SELECT SUM(premium_amount) AS total_premium
FROM policies;

SELECT CONCAT_WS(' ', c.first_name, c.last_name) AS customer_name,
COALESCE(SUM(p.premium_amount), 0) AS total_premium_paid FROM customers c
LEFT JOIN policies p ON c.customer_id = p.customer_id GROUP BY c.customer_id, c.first_name, c.last_name;

select concat(a.first_name, ' ', a.last_name) AS agent_name, count(p.Policy_Id) AS total_policies from agents a 
left join policies p on a.agent_id = p.agent_id group by a.first_name, a.last_name;

SELECT policy_id,SUM(amount_claimed) AS total_claim_amount FROM claims GROUP BY policy_id;

SELECT policy_id,status FROM claims WHERE status = 'Approved';

SELECT policy_id,SUM(amount) AS total_payment_received FROM payments GROUP BY policy_id


SELECT c.customer_id,CONCAT_WS(' ', c.first_name, c.last_name) AS customer_name,p.policy_id FROM customers c
LEFT JOIN policies p ON c.customer_id = p.customer_id;

SELECT policy_type,AVG(premium_amount) AS avg_premium_amount
FROM policies GROUP BY policy_type


SELECT CONCAT_WS(' ', a.first_name, a.last_name) AS agent_name,SUM(p.premium_amount * a.commission_rate / 100) AS total_commission FROM agents a
JOIN policies p ON a.agent_id = p.agent_id GROUP BY a.agent_id, a.first_name, a.last_name;