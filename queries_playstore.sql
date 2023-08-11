-- Comments in SQL Start with dash-dash --
-- 1. Find the app with an ID of 1880
SELECT * FROM analytics
WHERE id = 1880;

-- 2. Find the ID and app name for all apps that were last updated on August 01, 2018.
SELECT id, app_name from analytics
WHERE last_updated = DATE('2018/08/01');

-- 3. Count the number of apps in each category, e.g. “Family | 1972”.
SELECT category, COUNT(*) as num_of_apps FROM analytics
GROUP BY category;

-- 4. Find the top 5 most-reviewed apps and the number of reviews for each.
SELECT app_name, reviews FROM analytics
ORDER BY reviews DESC
LIMIT 5;

-- 5. Find the app that has the most reviews with a rating greater than equal to 4.8.
SELECT app_name, reviews, rating FROM analytics
WHERE rating >= 4.8
ORDER BY reviews DESC
LIMIT 1;

-- 6. Find the average rating for each category 
-- ordered by the highest rated to lowest rated.
SELECT category, AVG(rating) as avg_rating FROM analytics
GROUP BY category
ORDER BY avg_rating DESC;

-- 7. Find the name, price, 
-- and rating of the most expensive app with a rating that’s less than 3.
SELECT app_name, price, rating FROM analytics
WHERE rating < 3
ORDER BY price DESC
LIMIT 1;

-- 8. Find all apps with a min install not exceeding 50, that have a rating.
-- Order your results by highest rated first.
SELECT * FROM analytics
WHERE min_installs <= 50 and rating IS NOT NULL
ORDER BY rating DESC;

-- 9. Find the names of all apps that are 
-- rated less than 3 with at least 10000 reviews.
SELECT app_name, rating, reviews FROM analytics
WHERE rating < 3 and reviews >= 10000;

-- 10. Find the top 10 most-reviewed apps that cost between 10 cents and a dollar.
SELECT * FROM analytics
WHERE price BETWEEN 0.1 AND 1
ORDER BY reviews DESC
LIMIT 10;

-- 11. Find the most out of date app
SELECT * FROM analytics
WHERE last_updated < NOW()
ORDER BY last_updated ASC
LIMIT 1;

-- 12. Find the most expensive app (the query is very similar to #11).
SELECT * FROM analytics
WHERE price = (SELECT MAX(price) FROM analytics)
LIMIT 1;

-- 13. Count all the reviews in the Google Play Store
SELECT SUM(reviews) FROM analytics;

-- 14. Find all the categories that have more than 300 apps in them.
SELECT category, COUNT(*) as total_app FROM analytics
GROUP BY category 
HAVING COUNT(*) > 300;

-- 15. Find the app that has the highest proportion of min_installs to reviews, 
-- among apps that have been installed at least 100,000 times.
--
-- Display the name of the app along with 
-- the number of reviews, the min_installs, and the proportion.
SELECT app_name, reviews, min_installs, (min_installs / reviews) as proportion
FROM analytics
WHERE min_installs >= 100000 and min_installs / reviews = (
  SELECT MAX(min_installs / reviews) FROM analytics);

-- FS1. Find the name and rating of the top rated apps in each category, 
-- among apps that have been installed at least 50,000 times.
SELECT m.app_name, m.rating, m.category FROM analytics as m
INNER JOIN (
  SELECT MAX(s.rating) as max_rating, s.category FROM analytics as s 
  WHERE s.min_installs >= 50000
  GROUP BY category
) as sub ON m.rating = sub.max_rating AND m.category = sub.category
WHERE m.min_installs >= 50000;

-- FS2. Find all the apps that have a name similar to “facebook”.
SELECT * FROM analytics
WHERE app_name ILIKE '%facebook%';

-- FS3. Find all the apps that have more than 1 genre.
SELECT * FROM analytics as a
WHERE ARRAY_LENGTH(a.genres, 1) > 1;

-- FS4. Find all the apps that have education as one of their genres.
SELECT * FROM analytics as a
WHERE EXISTS (
  SELECT 1
  FROM unnest(a.genres) AS genre
  WHERE genre ILIKE 'education'
);