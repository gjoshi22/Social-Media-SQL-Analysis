# Social Media Platform SQL Analysis Project

## Introduction
This repository contains SQL queries and analyses conducted on a Social Media platform. The project aims to gain insights into user behavior, engagement metrics, content diversity, and other relevant aspects. Each SQL script addresses specific analytical questions, contributing to a comprehensive understanding of the platform dynamics.

## Project Structure
The project is structured as follows:

- SQL Scripts: The schema.sql files creates the database tables in RDBMS. The table.sql fills the table with all the relevant data for the required analysis. THe social_media_analysis.sql consists of the sql queries that perfrom the analysis.
- README.md: This README file providing an overview of the project and instructions for replicating the analyses.

## Analytical Queries

### 1. Identifying Top Trending Hashtags Over Time

**Description:**
This analysis focuses on understanding the popularity trends of hashtags over time on our social media platform. By examining the frequency of hashtag usage across different months, we aim to identify the top trending hashtags among our users. The SQL query aggregates data from three key tables—hashtags, post_tags, and posts—linking hashtags to posts based on their IDs. We group the data by hashtag name and month-year, enabling us to count the number of posts associated with each hashtag per month. This analysis provides valuable insights into which hashtags are currently trending and how their popularity fluctuates over different months, aiding in content strategy and user engagement optimization efforts on our platform. 📊

### 2. Identifying Users with High Engagement Rates

**Description:**
This analysis identifies users with the highest engagement rates based on the total number of post likes, comment likes, and follows received on our social media platform. The SQL query efficiently calculates user engagement metrics by joining the users table with post_likes, comment_likes, and follows tables. Using a Common Table Expression (CTE) named UserEngagement, the query aggregates the counts of post likes, comment likes, and follows per user ID. Subsequently, it computes the total engagement for each user by summing these counts. By retrieving user information and ordering the results by total engagement, this analysis effectively identifies influential users crucial for understanding key influencers within our platform community. 🔝

### 3. Analyzing Peak Login Times and User Activity

**Description:**
This analysis delves into user behavior patterns by analyzing peak login times and days of the week when users are most active on our social media platform. By examining login data, we aim to identify periods of high user activity, providing insights into user engagement patterns. The SQL query selects login times and counts the number of logins for each combination of day of the week and hour of the day. Through grouping and ordering the results, this analysis reveals peak login times and days, facilitating content scheduling optimization and targeted engagement strategies on our platform. ⏰

### 4. Measure Content Diversity and Engagement

**Description:**
This analysis aims to measure the diversity of content posted by users based on the variety of hashtags used and the types of media shared (such as photos and videos) on our social media platform. By analyzing the combination of hashtags and media types in user posts, we explore whether users who diversify their content portfolio tend to attract more engagement. The SQL query utilizes a Common Table Expression (CTE) named ContentDiversity to calculate this diversity. It selects user IDs and counts the number of distinct hashtags used and categorizes the content type as photo, video, or mixed. By grouping and aggregating data within each content type, this analysis provides insights into user content strategies and their impact on engagement metrics. 📸🎥

### 5. Analyzing User Location and Engagement Metrics

**Description:**
This analysis correlates user engagement metrics—such as post likes and comments—with user locations on our social media platform. By examining the relationship between user location and engagement levels, we aim to identify geographical areas with high user activity. The SQL query selects post locations and aggregates engagement metrics, including post likes and comments, for each location. By ordering the results based on total post likes and comments, this analysis reveals locations with the highest engagement levels, providing insights for targeted marketing and content localization strategies. 🌍

### 6. Comparing Engagement Metrics for Different Content Types

**Description:**
This analysis compares engagement metrics—such as likes and comments—between posts containing photos and videos on our social media platform. By analyzing user interactions with different types of content, we aim to identify which content type resonates better with users. The SQL query selects posts containing photos and videos and aggregates engagement metrics for each content type. By grouping the results by content type and summarizing engagement metrics, this analysis provides insights into user preferences and informs content creation strategies for optimizing user engagement on our platform. 👍💬

### 7. Segmenting Users Based on Profile Attributes

**Description:**
This analysis segments users based on their profile attributes—such as bio content, profile photo characteristics, and username length—on our social media platform. By categorizing users into distinct segments, we aim to understand their engagement levels and behaviors. The SQL query selects user profile attributes and aggregates engagement metrics, including total post likes and comments, for each user segment. By grouping the results by profile attributes and analyzing engagement metrics, this analysis provides insights for tailored marketing campaigns and user experience optimization strategies. 🧑‍💼

### 8. Clustering Users Based on Interaction Patterns

**Description:**
This analysis clusters users based on their interaction patterns—such as frequency of likes, comments, and follows—on our social media platform. By grouping users into distinct segments, we aim to identify unique behaviors and preferences among user groups. The SQL query selects user interaction metrics and categorizes users into engagement segments based on predefined thresholds. By analyzing user segments and their interaction patterns, this analysis provides insights for targeted content, promotions, and user experience strategies tailored to each segment's preferences. 🤝

### 9. Evaluating Hashtag Relevance in Post Captions

**Description:**
This analysis evaluates the relevance of hashtags used in post captions on our social media platform. By analyzing the semantic similarity between hashtag names and post captions, we aim to identify mismatches between hashtags and content topics. The SQL query selects posts containing hashtags and compares hashtag names with post captions. By filtering out posts without a match, this analysis identifies potential discrepancies and provides insights to improve content categorization and discovery, enhancing the user experience on our platform. 🔍

### 10. Identifying Users with Diverse Hashtag Interests

**Description:**
This analysis identifies users with diverse interests based on the variety of hashtags they follow on our social media platform. By measuring the number of unique hashtags followed by each user, we aim to rank users based on interest diversity. The SQL query selects user IDs and counts the number of distinct hashtags followed by each user. By ranking users based on the count of unique followed hashtags, this analysis provides insights into user interests and preferences, facilitating targeted content recommendations and user engagement strategies. 🌐

### 11. Analyzing User Engagement Through Comments

**Description:**
This analysis investigates user engagement through comments on our social media platform. By identifying the most active commenters, we aim to understand user participation and interaction levels. The SQL query selects user IDs and counts the number of comments made by each user. By ranking users based on their comment count, this analysis provides insights into user engagement behavior and facilitates targeted engagement strategies and community management efforts. 💬

### 12. Identifying Users with Consistent Posting Behavior

**Description:**
This analysis identifies users with consistent posting behavior on our social media platform. By analyzing the frequency of user posts over time, we aim to understand posting patterns and user engagement levels. The SQL query selects user IDs and creation dates of posts, calculates the number of posts made by each user on each day, and computes the rolling average of post counts for each user over a specified period. By analyzing user posting behavior, this analysis provides insights into user engagement trends and content creation strategies. 📅

### 13. Analyzing User Retention and Churn Rate

**Description:**
This analysis evaluates user retention and churn rate over time based on login data on our social media platform. By tracking daily user logins, we aim to understand user engagement trends and identify periods of user retention or churn. The SQL query selects login dates and counts user logins for each day, allowing us to calculate retention rates and churn rates over time. By analyzing user retention and churn, this analysis provides insights for improving user engagement and retention strategies. 🔄

## Usage
To replicate the analyses:

1. Clone this repository to your local machine.
2. Open each SQL script in your preferred database management tool.
3. Execute the queries against your database containing relevant data.
4. Review the results and insights obtained from each analysis.

## Conclusion
The SQL analyses conducted in this project provide valuable insights into various aspects of a Social Media Platform, including user engagement, content diversity, and user behavior patterns. By leveraging these insights, platform administrators can make informed decisions to enhance user experiences and optimize content strategies.
