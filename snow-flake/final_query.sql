USE DATABASE "UDACITY_PROJECT";
USE SCHEMA "UDACITY_PROJECT"."DWH";

SELECT fr.date, db.name, AVG(fr.stars) AS avg_stars, dte.temp_min, dte.temp_max, dtp.precipitation, dtp.precipitation_normal, db.city, db.state
FROM fact_review             AS fr
LEFT JOIN dim_business       AS db  ON fr.business_id = db.business_id
LEFT JOIN dim_temperature    AS dte ON fr.date = dte.date
LEFT JOIN dim_precipitation  AS dtp ON fr.date = dtp.date
GROUP BY fr.date, db.name, dte.temp_min, dte.temp_max, dtp.precipitation, dtp.precipitation_normal, db.city, db.state
ORDER BY fr.date DESC;