-- Find number of businesses in each category
USE DATABASE yelp;
USE SCHEMA PUBLIC;

WITH cte AS (
SELECT business_id, trim(A.value) AS category FROM tbl_yelp_businesses,
lateral split_to_table(categories, ',') A
)
SELECT category, count(*) FROM cte GROUP BY 1 ORDER BY count(*) DESC


-- number of reviews a person has given for all RESTAURANTS businesses
WITH cte AS (
SELECT business_id, trim(A.value) AS category FROM tbl_yelp_businesses,
lateral split_to_table(categories, ',') A
WHERE category = 'Restaurants'
)
SELECT user_id, count(*) FROM tbl_yelp_reviews INNER JOIN cte ON tbl_yelp_reviews.business_id = cte.business_id 
GROUP BY user_id ORDER BY 2 DESC


--Find the top 10 users who have reviewed the most businesses in the "Restaurants" category
SELECT reviews.user_id, count(DISTINCT reviews.business_id) 
FROM tbl_yelp_businesses business INNER JOIN tbl_yelp_reviews reviews ON reviews.business_id = business.business_id 
WHERE business.categories ilike '%Restaurants%' GROUP BY 1 ORDER BY 2 DESC limit 10


--Find the most popular categories of businesses (based on the number of reviews)
WITH cte AS (
SELECT business_id, trim(A.value) AS category FROM tbl_yelp_businesses,
lateral split_to_table(categories, ',') A
)
SELECT category, count(*) FROM tbl_yelp_reviews rev JOIN cte ON rev.business_id = cte.business_id 
GROUP BY category ORDER BY 2 DESC


-- Find the top 3 most recent reviews for each business
WITH recent_reviews AS (
SELECT b.business_id, b.name, r.review_date, r.review_text ,
ROW_NUMBER() OVER(PARTITION BY r.business_id ORDER BY review_date DESC) AS rn
FROM tbl_yelp_reviews r JOIN tbl_yelp_businesses b ON r.business_id = b.business_id
)
SELECT * FROM recent_reviews WHERE rn<=3


-- Find the month with the highest number of reviews
USE DATABASE yelp;
USE SCHEMA PUBLIC;

SELECT MONTH(review_date), MONTHNAME(review_date), count(*) FROM tbl_yelp_reviews 
GROUP BY MONTH(review_date), MONTHNAME(review_date) ORDER BY count(*) DESC


--Find the percentage of 5 star reviews for each business
SELECT b.business_id, b.name, 
COUNT(*) AS total_reviews, 
SUM(CASE WHEN r.review_stars = 5 then 1 ELSE 0 END) AS five_stars,
((five_stars/total_reviews)*100) AS percentage
FROM tbl_yelp_businesses b JOIN tbl_yelp_reviews r ON b.business_id = r.business_id 
GROUP BY 1,2 ORDER BY percentage DESC


--Find the TOP 5 most reviewed businesses in each city
WITH cte AS (
SELECT b.city, b.business_id, b.name, COUNT(*) AS total_reviews
FROM tbl_yelp_businesses b JOIN tbl_yelp_reviews r ON b.business_id = r.business_id GROUP BY 1,2,3
)
SELECT * FROM cte
QUALIFY ROW_NUMBER() OVER(PARTITION BY city ORDER BY total_reviews DESC) <= 5


--Find the average rating of businesses that have at least 100 reviews
SELECT b.business_id, b.name, COUNT(*), AVG(review_stars) 
FROM tbl_yelp_reviews r INNER JOIN tbl_yelp_businesses b ON b.business_id = r.business_id
GROUP BY 1,2 HAVING COUNT(review_stars) >= 100 ORDER BY AVG(review_stars)


--List the top 10 users who have written the most reviews, along with the businesses they reviewed
SELECT r.user_id, COUNT(*) AS total_reviews, 
LISTAGG(DISTINCT b.name, ', ') WITHIN GROUP (ORDER BY b.name) AS businesses_reviewed
FROM tbl_yelp_businesses b INNER JOIN tbl_yelp_reviews r ON r.business_id = b.business_id 
GROUP BY 1 ORDER BY total_reviews DESC limit 10


--Find top 10 businesses with highest positive sentiment reviews
SELECT b.business_id, b.name, count(*) AS positive_sentiments
FROM tbl_yelp_businesses b INNER JOIN tbl_yelp_reviews r ON r.business_id = b.business_id 
WHERE r.sentiments = 'Positive'
GROUP BY 1,2 ORDER BY positive_sentiments DESC limit 10
