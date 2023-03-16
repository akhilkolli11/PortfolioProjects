--We want to recognize and offer incentives to our users who have been with us for the longest period of time. 
Find the 5 oldest users.*/
SELECT * FROM users
ORDER BY created_at
LIMIT 5;


--On which day of the week do the majority of the users sign up?
--Need to determine the optimal time to schedule our advertising program
SELECT date_format(created_at,'%W') AS 'day of the week', COUNT(*) AS 'total registration'
FROM users
GROUP BY 1
ORDER BY 2 DESC;

--alternate way
SELECT 
DAYNAME(created_at) AS day,
COUNT(*) AS total
FROM users
GROUP BY day
ORDER BY total DESC
LIMIT 2;


--Our goal is to focus on our inactive users by launcing an email campaign.
--Identify the users who have never uploaded a photo.
SELECT username
FROM users
LEFT JOIN photos ON users.id = photos.user_id
WHERE photos.id IS NULL;


--We're running a new contest to see who can get the most likes on a single photo.
--WHO WON??
SELECT users.username,photos.id,photos.image_url,COUNT(*) AS Total_Likes
FROM likes
JOIN photos ON photos.id = likes.photo_id
JOIN users ON users.id = likes.user_id
GROUP BY photos.id
ORDER BY Total_Likes DESC
LIMIT 1;

--Alternate way
SELECT 
username,
photos.id,
photos.image_url, 
COUNT(*) AS total
FROM photos
INNER JOIN likes
ON likes.photo_id = photos.id
INNER JOIN users
ON photos.user_id = users.id
GROUP BY photos.id
ORDER BY total DESC
LIMIT 1;


--Our investors are interested in knowing the average frequency at which users post content.
--Can be calculated by diving the total number of photos by the total number of users.
SELECT ROUND((SELECT COUNT(*)FROM photos)/(SELECT COUNT(*) FROM users),2);


--User ranking by postings higher to lower
SELECT users.username,COUNT(photos.image_url)
FROM users
JOIN photos ON users.id = photos.user_id
GROUP BY users.id
ORDER BY 2 DESC;


--Total Posts by users 
SELECT SUM(user_posts.total_posts_per_user)
FROM (SELECT users.username,COUNT(photos.image_url) AS total_posts_per_user
		FROM users
		JOIN photos ON users.id = photos.user_id
		GROUP BY users.id) AS user_posts;


--Total numbers of users who have posted at least one time 
SELECT COUNT(DISTINCT(users.id)) AS total_number_of_users_with_posts
FROM users
JOIN photos ON users.id = photos.user_id;


--A brand wants to know which hashtags to use in a post
--What are the top 5 most commonly used hashtags?*/
SELECT tag_name, COUNT(tag_name) AS total
FROM tags
JOIN photo_tags ON tags.id = photo_tags.tag_id
GROUP BY tags.id
ORDER BY total DESC;


--We have a small problem with bots on our site.
--Find users who have liked every single photo on the site*/
SELECT users.id,username, COUNT(users.id) As total_likes_by_user
FROM users
JOIN likes ON users.id = likes.user_id
GROUP BY users.id
HAVING total_likes_by_user = (SELECT COUNT(*) FROM photos);

--We also have a problem with celebrities
--Find users who have never commented on a photo*/
SELECT username,comment_text
FROM users
LEFT JOIN comments ON users.id = comments.user_id
GROUP BY users.id
HAVING comment_text IS NULL;

SELECT COUNT(*) FROM
(SELECT username,comment_text
FROM users
LEFT JOIN comments ON users.id = comments.user_id
GROUP BY users.id
HAVING comment_text IS NULL) AS total_number_of_users_without_comments;

