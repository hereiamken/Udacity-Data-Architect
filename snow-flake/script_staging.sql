USE DATABASE "UDACITY_PROJECT";
USE SCHEMA "UDACITY_PROJECT"."STAGING";

/*CREATE TEMPORAGE TABLES*/
DROP TABLE IF EXISTS covid_features_stg; 
CREATE TABLE covid_features_stg (covid_info VARIANT);

DROP TABLE IF EXISTS business_stg;
CREATE TABLE business_stg (business_info VARIANT);

DROP TABLE IF EXISTS checkin_stg;
CREATE TABLE checkin_stg (checkin_info VARIANT);

DROP TABLE IF EXISTS review_stg;
CREATE TABLE review_stg (review_info VARIANT);

DROP TABLE IF EXISTS tip_stg;
CREATE TABLE tip_stg (tip_info VARIANT);

DROP TABLE IF EXISTS user_stg;
CREATE TABLE user_stg (user_info VARIANT);

DROP TABLE IF EXISTS precipitation_stg;
CREATE TABLE precipitation_stg (date STRING, precipitation STRING, precipitation_normal STRING);

DROP TABLE IF EXISTS temperature_stg;
CREATE TABLE temperature_stg (period STRING, min_value STRING, max_value STRING, normal_min STRING, normal_max STRING);

create or replace file format json_format type = json;

create or replace stage staging_area file_format = json_format;

/*COPY FILES INTO TEMPORARY TABLES*/
COPY INTO covid_features_stg FROM @staging_area/yelp_academic_dataset_covid_features.json file_format=(type=JSON);

COPY INTO business_stg FROM @staging_area/yelp_academic_dataset_business.json file_format=(type=JSON);

COPY INTO checkin_stg FROM @staging_area/yelp_academic_dataset_checkin.json file_format=(type=JSON);

COPY INTO review_stg FROM @staging_area/yelp_academic_dataset_review.json file_format=(type=JSON);

COPY INTO tip_stg FROM @staging_area/yelp_academic_dataset_tip.json file_format=(type=JSON);

COPY INTO user_stg FROM @staging_area/yelp_academic_dataset_user.json file_format=(type=JSON);

COPY INTO precipitation_stg FROM @staging_area/usw00023169-las-vegas-mccarran-intl-ap-precipitation-inch.csv file_format=(type=csv field_delimiter=',', skip_header=1);

COPY INTO temperature_stg FROM @staging_area/usw00023169-temperature-degreef.csv file_format=(type=csv field_delimiter=',', skip_header=1);


