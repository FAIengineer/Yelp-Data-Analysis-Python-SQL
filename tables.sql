USE DATABASE YELP; 
USE SCHEMA PUBLIC;

CREATE OR REPLACE TABLE yelp_reviews (review_text VARIANT);

COPY INTO yelp_reviews
FROM 's3://shiro/yelp/'
CREDENTIALS = (
    AWS_KEY_ID = '********************'
    AWS_SECRET_KEY = '************************'
)
FILE_FORMAT = (TYPE = JSON);



CREATE OR REPLACE TABLE tbl_yelp_reviews AS
SELECT review_text:business_id::STRING AS business_id,
review_text:user_id::STRING AS user_id,
review_text:date::date AS review_date,
review_text:stars::decimal AS review_stars,
review_text:text::STRING AS review_text,
analyze_sentiment(review_text) AS sentiments 
FROM yelp_reviews


-- YELP BUSINESSES

create or replace table yelp_businesses (business_text variant)

COPY INTO yelp_businesses
FROM 's3://shiro/yelp/yelp_academic_dataset_business.json'
CREDENTIALS = (
    AWS_KEY_ID = '********************'
    AWS_SECRET_KEY = '************************'
)
FILE_FORMAT = (TYPE = JSON);

CREATE OR REPLACE TABLE tbl_yelp_businesses AS
SELECT business_text:business_id::STRING AS business_id,
business_text:name::STRING as name,
business_text:categories::STRING as categories,
business_text:city::STRING as city,
business_text:state::STRING as state,
business_text:postal_code::STRING as postal_code,
business_text:stars::DECIMAL as stars
FROM yelp_businesses

SELECT * FROM tbl_yelp_businesses limit 100