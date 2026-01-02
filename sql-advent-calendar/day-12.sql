-- SQL Advent Calendar - Day 12
-- Title: North Pole Network Most Active Users
-- Difficulty: hard
--
-- Question:
-- The North Pole Network wants to see who's the most active in the holiday chat each day. Write a query to count how many messages each user sent, then find the most active user(s) each day. If multiple users tie for first place, return all of them.
--
-- The North Pole Network wants to see who's the most active in the holiday chat each day. Write a query to count how many messages each user sent, then find the most active user(s) each day. If multiple users tie for first place, return all of them.
--

-- Table Schema:
-- Table: npn_users
--   user_id: INT
--   user_name: VARCHAR
--
-- Table: npn_messages
--   message_id: INT
--   sender_id: INT
--   sent_at: TIMESTAMP
--

-- My Solution:

WITH number_of_messages AS(
  SELECT sender_id, 
  DATE(sent_at) as day, 
  count(message_id) AS message_count
  FROM npn_messages
  GROUP BY sender_id, DATE(sent_at)
),
active_users AS(
  SELECT day, sender_id, message_count,
  RANK() OVER(partition by day ORDER BY message_count DESC) as active_rank
  FROM number_of_messages
)

SELECT a.day, u.user_id, u.user_name, a.message_count
FROM active_users a
JOIN npn_users u
ON u.user_id = a.sender_id
WHERE a.active_rank = 1
ORDER BY a.day, u.user_id
