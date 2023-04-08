USE DATABASE "UDACITY_PROJECT";
USE SCHEMA "UDACITY_PROJECT"."DWH";

/* Table dim_timestamp */
CREATE OR REPLACE TABLE dim_timestamp (
    timestamp DATETIME PRIMARY KEY,
    date      DATE,
    day       INT,
    week      INT,
    month     INT,
    year      INT
);

/* Table dim_user */
CREATE OR REPLACE TABLE dim_user (
    user_id TEXT PRIMARY KEY,
    name TEXT,
    review_count INT,
    yelping_since DATETIME,
    useful              INT,
    funny               INT,
    cool                INT,
    elite               TEXT,
    friends             TEXT,
    fans                INT,
    average_stars NUMERIC(3,2),
    compliment_hot      INT,
    compliment_more     INT,
    compliment_profile  INT,
    compliment_cute     INT,
    compliment_list     INT,
    compliment_note     INT,
    compliment_plain    INT,
    compliment_cool     INT,
    compliment_funny    INT,
    compliment_writer   INT,
    compliment_photos   INT
);

/* Table dim_temperature */
CREATE OR REPLACE TABLE dim_temperature (
    date DATE PRIMARY KEY,
    temp_min FLOAT,
    temp_max FLOAT,
    temp_normal_min FLOAT,
    temp_normal_max FLOAT
);

CREATE OR REPLACE TABLE dim_precipitation (
    date DATE PRIMARY KEY,
    precipitation               FLOAT,
    precipitation_normal        FLOAT
);

CREATE OR REPLACE TABLE dim_business (
    business_id TEXT PRIMARY KEY,
    name TEXT,
    address TEXT,
    city TEXT,
    state TEXT,
    postal_code TEXT,
    latitude FLOAT,
    longitude FLOAT,
    stars NUMERIC(3,2),
    review_count INT,
    is_open INT,
    attributes OBJECT,
    categories TEXT,
    hours VARIANT,
    checkin_date TEXT,
    covid_highlights                TEXT,
    covid_delivery_or_takeout       TEXT,
    covid_grubhub_enabled           TEXT,
    covid_call_to_action_enabled    TEXT,
    covid_request_a_quote_enabled   TEXT,
    covid_banner                    TEXT,
    covid_temporary_closed_until    TEXT,
    covid_virtual_services_offered  TEXT
);

/* Table fact_review */
CREATE OR REPLACE TABLE fact_review (
    review_id           TEXT        PRIMARY KEY,
    user_id             TEXT,
    business_id         TEXT,
    stars               NUMERIC(3,2),
    useful              BOOLEAN,
    funny               BOOLEAN,
    cool                BOOLEAN,
    text                TEXT,
    timestamp           DATETIME,
    date                DATE,
    CONSTRAINT FK_US_ID FOREIGN KEY(user_id)        REFERENCES  dim_user(user_id),
    CONSTRAINT FK_BU_ID FOREIGN KEY(business_id)    REFERENCES  dim_business(business_id),
    CONSTRAINT FK_TI_ID FOREIGN KEY(timestamp)      REFERENCES  dim_timestamp(timestamp),
    CONSTRAINT FK_TE_ID FOREIGN KEY(date)           REFERENCES  dim_temperature(date),
    CONSTRAINT FK_PR_ID FOREIGN KEY(date)           REFERENCES  dim_precipitation(date)
);

TRUNCATE dim_business;
TRUNCATE dim_user;
TRUNCATE dim_timestamp;
TRUNCATE dim_temperature;
TRUNCATE dim_precipitation;
TRUNCATE fact_review;

/*dim_business*/
INSERT INTO dim_business(business_id ,name ,address ,city, state, postal_code, latitude, longitude , stars, review_count, is_open, attributes, categories, hours, checkin_date, covid_highlights, covid_delivery_or_takeout,
covid_grubhub_enabled, covid_call_to_action_enabled, covid_request_a_quote_enabled, covid_banner, covid_temporary_closed_until, covid_virtual_services_offered)
SELECT 
    bu.business_id,
    bu.name,
    bu.address,
    bu.city,
    bu.state,
    bu.postal_code,
    bu.latitude,
    bu.longitude,
    bu.stars,
    bu.review_count,
    bu.is_open,
    bu.attributes,
    bu.categories,
    bu.hours,
    ch.date,
    co.highlights,
    co.delivery_or_takeout,
    co.grubhub_enabled,
    co.call_to_action_enabled,
    co.request_a_quote_enabled,
    co.covid_banner,
    co.temporary_closed_until,
    co.virtual_services_offered
FROM "UDACITY_PROJECT"."ODS".business AS bu
LEFT JOIN "UDACITY_PROJECT"."ODS".checkin AS ch ON bu.business_id = ch.business_id
LEFT JOIN "UDACITY_PROJECT"."ODS".covid AS co ON bu.business_id = co.business_id;

/*dim_user*/
INSERT INTO dim_user(user_id, name, review_count, yelping_since, useful, funny, cool, elite, friends, fans, average_stars, compliment_hot, compliment_more, compliment_profile, compliment_cute, compliment_list, compliment_note, compliment_plain, compliment_cool, compliment_funny, compliment_writer, compliment_photos)
SELECT 
    us.user_id,
    us.name,
	us.review_count,
	us.yelping_since,
    us.useful,
    us.funny,
    us.cool,
	us.elite,
    us.friends,
	us.fans,
    us.average_stars,
    us.compliment_hot,
    us.compliment_more,
    us.compliment_profile,
    us.compliment_cute,
    us.compliment_list,
    us.compliment_note,
    us.compliment_plain,
	us.compliment_cool,
	us.compliment_funny,
	us.compliment_writer,
	us.compliment_photos	
FROM "UDACITY_PROJECT"."ODS".user AS us;

/*dim_temperature*/
INSERT INTO dim_temperature (date, temp_min, temp_max, temp_normal_min, temp_normal_max)
SELECT te.date, te.temp_min, te.temp_max, te.temp_normal_min, te.temp_normal_max
FROM "UDACITY_PROJECT"."ODS".temperature AS te;

/*dim_precipitation*/
INSERT INTO dim_precipitation (date, precipitation, precipitation_normal)
SELECT pr.date, pr.precipitation, pr.precipitation_normal
FROM "UDACITY_PROJECT"."ODS".precipitation AS pr;

/*dim_timestamp*/
INSERT INTO dim_timestamp (timestamp, date, day, week, month, year)
SELECT r.timestamp,
       DATE(r.timestamp),
       DAY(r.timestamp),
       WEEK(r.timestamp),
       MONTH(r.timestamp),
       YEAR(r.timestamp) 
FROM "UDACITY_PROJECT"."ODS".review AS r
WHERE r.timestamp NOT IN (SELECT timestamp FROM dim_timestamp);

/*fact_review*/
INSERT INTO fact_review (review_id, user_id, business_id, stars, useful, funny, cool, text, timestamp, date)
SELECT  re.review_id,
        re.user_id,
        re.business_id,
        re.stars,
        re.useful,
        re.funny,
        re.cool,
        re.text,
        re.timestamp,
        ti.date
FROM "UDACITY_PROJECT"."ODS".review AS re
INNER JOIN dim_timestamp AS ti ON re.timestamp = ti.timestamp;