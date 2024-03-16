-- 1. Identifying the top trending hashtags by analyzing the frequency of their usage over time.

 select hh.hashtag_name from (SELECT 
    h.hashtag_name, 
    DATE_FORMAT(p.created_at, '%Y-%m') AS month_year,
    COUNT(pt.post_id) AS post_count
FROM 
    hashtags h
JOIN 
    post_tags pt ON h.hashtag_id = pt.hashtag_id
JOIN 
    post p ON pt.post_id = p.post_id
GROUP BY 
    h.hashtag_name, month_year
ORDER BY 
    month_year DESC, post_count DESC limit 10) as hh;
    
/*In this analysis, we examine hashtags' popularity over time.
By combining data from three tables—hashtags, post_tags, and 
post—we link hashtags to posts based on their IDs. 
We group the data by hashtag_name and month_year, 
allowing us to count the number of posts associated with 
each hashtag per month. Using this information, we identify 
trends in hashtag usage over time. This analysis helps us 
understand which hashtags are currently trending and 
how their popularity fluctuates over different months.
*/

-- 2. Identify users who have the highest engagement rates based on the total number of post likes, comment likes, and follows received. 

WITH UserEngagement AS (
    SELECT 
        u.user_id,
        COUNT(DISTINCT pl.post_id) AS total_post_likes,
        COUNT(DISTINCT cl.comment_id) AS total_comment_likes,
        COUNT(DISTINCT f.follower_id) AS total_follows
    FROM 
        users u
    LEFT JOIN 
        post_likes pl ON u.user_id = pl.user_id
    LEFT JOIN 
        comment_likes cl ON u.user_id = cl.user_id
    LEFT JOIN 
        follows f ON u.user_id = f.followee_id
    GROUP BY 
        u.user_id
)
SELECT 
    ue.user_id,
    u.username,
    ue.total_post_likes,
    ue.total_comment_likes,
    ue.total_follows,
    (ue.total_post_likes + ue.total_comment_likes + ue.total_follows) AS total_engagement
FROM 
    UserEngagement ue
JOIN 
    users u ON ue.user_id = u.user_id
ORDER BY 
    total_engagement DESC;

/*

This SQL query efficiently identifies users with the highest 
engagement rates within the dataset. It achieves this by first
calculating the total number of post likes, comment likes, and
follows received by each user. Utilizing a Common Table 
Expression (CTE) named UserEngagement, the query joins 
relevant tables - post_likes, comment_likes, and follows - 
with the users table, grouping the results by user ID to 
aggregate the counts of interactions. Subsequently, the 
query computes the total engagement for each user by summing 
the counts of post likes, comment likes, and follows. Finally,
the query retrieves user information, including their 
usernames, and orders the results by total engagement in 
descending order. This approach effectively identifies 
influential users with the highest engagement rates, 
crucial for understanding key influencers within the platform.
*/

-- 3. Analyze the login table to determine peak login times and days of the week when users are most active.
-- This can provide insights into user behavior patterns and help optimize content scheduling.

SELECT 
    DAYOFWEEK(login_time) AS day_of_week,
    HOUR(login_time) AS hour_of_day,
    COUNT(*) AS login_count
FROM 
    login
GROUP BY 
    DAYOFWEEK(login_time), HOUR(login_time)
ORDER BY 
    day_of_week, hour_of_day;

/* This SQL query analyzes the login table to determine peak login times and days of the week when users are most active. 
It achieves this by selecting the day of the week and hour of the day from the login_time column using the DAYOFWEEK() and 
HOUR() functions, respectively. Then, it counts the number of logins for each combination of day of the week and hour of the 
day using the COUNT(*) function. By grouping the results by day of the week and hour of the day using the GROUP BY clause, 
it aggregates the login counts accordingly. Finally, the results are ordered by day of the week and hour of the day to provide 
insights into user behavior patterns, helping optimize content scheduling based on peak login times.*/


-- 4. Measure the diversity of content posted by users based on the variety of hashtags used and the types of media (photos, videos)
-- shared. Explore whether users who diversify their content portfolio tend to attract more engagement.

WITH ContentDiversity AS (
    SELECT 
        p.user_id,
        COUNT(DISTINCT pt.hashtag_id) AS hashtag_count,
        CASE 
            WHEN MAX(ph.photo_id) IS NOT NULL AND MAX(v.video_id) IS NULL THEN 'photo'
            WHEN MAX(ph.photo_id) IS NULL AND MAX(v.video_id) IS NOT NULL THEN 'video'
            ELSE 'mixed'
        END AS content_type
    FROM 
        post p
    LEFT JOIN 
        post_tags pt ON p.post_id = pt.post_id
    LEFT JOIN 
        photos ph ON p.photo_id = ph.photo_id
    LEFT JOIN 
        videos v ON p.video_id = v.video_id
    GROUP BY 
        p.user_id
)
SELECT 
    cd.user_id,
    cd.content_type,
    cd.hashtag_count,
    COUNT(*) AS post_count
FROM 
    ContentDiversity cd
GROUP BY 
    cd.user_id, cd.content_type, cd.hashtag_count;
    
    /*
    This SQL query measures the diversity of content posted by users based 
    on the variety of hashtags used and the types of media shared (photos, videos). 
    It utilizes a Common Table Expression (CTE) named ContentDiversity to calculate 
    this diversity. Firstly, it selects the user ID (user_id) from the post table and 
    counts the number of distinct hashtags used (hashtag_count) by 
    joining with the post_tags table. Additionally, it determines the 
    type of content posted (content_type) by checking if a post contains a 
    photo, a video, or a combination of both. This is done by joining with 
    the photos and videos tables and using a CASE statement to categorize
    the content type accordingly.
    */
    
    -- 5.  Investigate whether there's a correlation between user location and 
    -- engagement metrics such as post likes and comments. This analysis can 
    -- help in targeted marketing and content localization strategies.
    
    SELECT
    p.location,
    COUNT(DISTINCT pl.post_id) AS total_post_likes,
    COUNT(DISTINCT c.comment_id) AS total_comments
FROM
    post p
LEFT JOIN
    post_likes pl ON p.post_id = pl.post_id
LEFT JOIN
    comments c ON p.post_id = c.post_id
GROUP BY
    p.location
ORDER BY
    total_post_likes DESC, total_comments DESC;

/* This SQL query correlates user engagement metrics—post likes and 
comments—with post locations. It first joins the post, post_likes, and 
comments tables to associate engagement metrics with post locations. 
Using LEFT JOINs ensures inclusion of all post locations. Next, it 
aggregates engagement metrics by post location. The results are 
then ordered by total post likes and comments in descending order, 
revealing locations with the highest engagement. This analysis aids in 
targeted marketing and content localization strategies by highlighting 
areas of high user activity. */

-- 6. Compare the engagement metrics (likes, comments) between posts containing photos 
-- and videos to identify which type of content resonates better with users. 
-- This can inform content creation strategies for the platform.

SELECT
    content_type,
    SUM(IFNULL(pl.like_count, 0)) AS total_likes,
    SUM(IFNULL(c.comment_count, 0)) AS total_comments
FROM
    (SELECT
        'photo' AS content_type,
        post_id
    FROM
        photos
    UNION ALL
    SELECT
        'video' AS content_type,
        post_id
    FROM
        videos) AS content
LEFT JOIN
    (SELECT
        post_id,
        COUNT(*) AS like_count
    FROM
        post_likes
    GROUP BY
        post_id) AS pl ON content.post_id = pl.post_id
LEFT JOIN
    (SELECT
        post_id,
        COUNT(*) AS comment_count
    FROM
        comments
    GROUP BY
        post_id) AS c ON content.post_id = c.post_id
GROUP BY
    content_type;
    
/* This SQL query compares engagement metrics (likes and comments) between posts 
containing photos and videos. It begins by creating a derived table (content) 
that combines photos and videos while distinguishing between them 
using the content_type column. Subsequently, the derived table is left 
joined with aggregate subqueries to compute the total likes and comments 
for each content type. The use of the IFNULL function ensures proper 
handling of cases where there are no likes or comments for a specific 
post type. Finally, the results are grouped by content_type, providing 
a summarized view of engagement metrics for photos and videos. 
This analysis offers valuable insights into user preferences regarding 
content types, aiding content creators in refining their strategies to 
optimize user engagement on the platform. */

-- 7. Segment users based on profile attributes such as bio content, profile photo 
-- characteristics, and username length. Analyze the engagement levels and behaviors 
-- of different user segments to tailor marketing campaigns and user experiences.
SELECT
    CASE
        WHEN LENGTH(u.bio) < 50 THEN 'Short Bio'
        WHEN LENGTH(u.bio) >= 50 AND LENGTH(u.bio) < 100 THEN 'Medium Bio'
        ELSE 'Long Bio'
    END AS bio_segment,
    CASE
        WHEN LENGTH(u.username) < 8 THEN 'Short Username'
        ELSE 'Long Username'
    END AS username_segment,
    CASE
        WHEN u.profile_photo_url IS NULL THEN 'No Profile Photo'
        ELSE 'Has Profile Photo'
    END AS photo_segment,
    COUNT(DISTINCT pl.post_id) AS total_post_likes,
    COUNT(DISTINCT c.comment_id) AS total_comments
FROM
    users u
LEFT JOIN
    post_likes pl ON u.user_id = pl.user_id
LEFT JOIN
    comments c ON u.user_id = c.user_id
GROUP BY
    bio_segment, username_segment, photo_segment;
    
/* This SQL analysis segments users based on their profile attributes, 
including bio content length, username length, and profile photo presence. 
It then joins these user segments with engagement metrics from post likes and 
comments. By grouping and aggregating data within each segment, the query 
calculates total post likes and comments. This provides insights into the 
engagement levels of users across different profile attribute segments. 
This approach enables tailored marketing campaigns and user experiences, 
leveraging user profile characteristics to optimize engagement strategies 
on the platform. */
    
-- 8. Cluster users based on their interaction patterns, such as frequency of 
-- likes, comments, and follows. Explore whether distinct user segments exhibit
-- unique behaviors and preferences, and how these segments can be targeted 
-- differently.


SELECT
    user_id,
    CASE
        WHEN total_likes >= 10 AND total_comments >= 5 AND total_follows >= 3 THEN 'Highly Engaged'
        WHEN total_likes >= 5 AND total_comments >= 3 AND total_follows >= 2 THEN 'Moderately Engaged'
        ELSE 'Low Engagement'
    END AS engagement_segment
FROM (
    SELECT
        pl.user_id,
        COUNT(DISTINCT pl.post_id) AS total_likes,
        COUNT(DISTINCT c.comment_id) AS total_comments,
        COUNT(DISTINCT f.followee_id) AS total_follows
    FROM
        post_likes pl
    LEFT JOIN
        comments c ON pl.user_id = c.user_id
    LEFT JOIN
        follows f ON pl.user_id = f.follower_id
    GROUP BY
        pl.user_id
) AS user_engagement;

/* 
This SQL analysis segments users based on their interaction patterns, 
encompassing likes, comments, and follows. It first calculates engagement 
metrics by aggregating the total number of likes, comments, and follows 
per user across posts. Next, users are categorized into distinct segments 
such as 'Highly Engaged,' 'Moderately Engaged,' and 'Low Engagement' based 
on predefined thresholds for interaction levels. Lastly, the query outputs 
user IDs along with their corresponding engagement segments, facilitating 
the understanding of user behavior and enabling targeted strategies for 
content, promotions, and user experiences tailored to each segment's 
preferences. */

-- 9. Evaluate the relevance of hashtags used in posts by analyzing the 
-- semantic similarity between hashtag names and post captions. 
-- Identify mismatches between hashtags and content topics to improve 
-- content categorization and discovery.

SELECT
    pt.post_id,
    pt.hashtag_id,
    h.hashtag_name AS actual_hashtag,
    p.caption AS post_caption
FROM
    post_tags pt
JOIN
    hashtags h ON pt.hashtag_id = h.hashtag_id
JOIN
    post p ON pt.post_id = p.post_id
WHERE
    NOT INSTR(LOWER(p.caption), LOWER(h.hashtag_name)) > 0;

/* 
This SQL analysis evaluates hashtag relevance by comparing hashtag names with 
post captions. It involves joining tables containing post tags, hashtags, 
and post content, followed by a comparison using the INSTR() function to 
check for hashtag appearance within the post caption. Filtering out posts 
without a match identifies potential mismatches between hashtags and content
 topics. By recognizing these discrepancies, the analysis provides insights 
 to refine content categorization and enhance content discovery, ensuring 
 hashtags accurately represent post themes and improving the user experience.
 */
 
 -- 10.  Identifying users with the most diverse hashtags and ranking them. 

SELECT
    user_id,
    COUNT(DISTINCT hashtag_id) AS num_unique_followed_hashtags,
    RANK() OVER (ORDER BY COUNT(DISTINCT hashtag_id) DESC) AS interest_diversity_rank
FROM
    hashtag_follow
GROUP BY user_id;

-- This query calculates the number of hashtags each user follows and ranks them based on the count.

 -- 11. Identifying most active commenters in the social media app. 
 
 SELECT
    user_id,
    COUNT(*) AS num_comments,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS comment_rank
FROM
    comments
GROUP BY user_id;

-- This query counts the number of comments made by each user and ranks them based on their comment count.

-- 12. Identifying Users with Consistent Posting Behavior.
SELECT
    user_id,
    created_date,
    COUNT(*) AS num_posts,
    AVG(COUNT(*)) OVER (PARTITION BY user_id ORDER BY created_date RANGE BETWEEN INTERVAL 7 DAY PRECEDING AND CURRENT ROW) AS weekly_avg_posts
FROM
    post
GROUP BY
    user_id,
    created_date;
    
/* This query selects user IDs and creation dates from the "post" table, 
counts the number of posts for each user on each day, utilizes a window 
function to calculate the rolling average of post counts for each user over 
a 7-day period, retrieves data from the "post" table, and groups the
 results by user ID and creation date. */
 
-- 13. Analyze user retention and churn rate over time based on login data.

SELECT
    date,
    total_users,
    LAG(total_users, 1) OVER (ORDER BY date) AS previous_total_users,
    total_users - LAG(total_users, 1) OVER (ORDER BY date) AS user_growth,
    1 - (total_users / LAG(total_users, 1) OVER (ORDER BY date)) AS churn_rate
FROM
    (
        SELECT
            DATE(login_time) AS date,
            COUNT(DISTINCT user_id) AS total_users
        FROM
            login
        GROUP BY
            DATE(login_time)
    ) AS user_counts;

/* 
This query tracks daily user logins, calculates user growth, and churn rate 
over time. It begins by selecting login dates and counting distinct user IDs 
per day. Utilizing window functions, specifically the "LAG" function, it 
determines the previous day's total users. The resulting metrics include the 
date, total users, lagged total users, user growth, and churn rate, 
providing valuable insights into user engagement trends.

/*

