\c flame_forum;

TRUNCATE TABLE karma, users, topics, comments 
Restart Identity;

INSERT INTO users
  (fname, lname, handle, email, password, date_joined, is_admin)
VALUES
  ('Lauren', 'Ipsum', '@Ins3rtP3rsonality', 'ins3rt_P3rsonality@gmail.com', 'password123', '1987-06-10 15:06:24.510098','F'),
  ('david', 'Neuhaus', '@neuhausneuhaus', 'jewhaus@gmail.com', 'abc123', '1991-12-11 03:06:12','T'),
  ('Jane', 'Doe', '@JD4eVa', 'jane.doe@aol.com', 'blue42', CURRENT_TIMESTAMP,'F');


--USER EXAMPLE WITH BIO
INSERT INTO users
  (fname, lname, handle, email, password, date_joined, bio)
VALUES
  ('Michael', 'Finnigan', '@Whisker_Chin', 'hairEfayce@hotmail.com', 'gillette', CURRENT_TIMESTAMP, 'DYK? There are whiskers on my chin (again)');


INSERT INTO topics 
  (topic_creator_id, topic_title, topic_subtitle, topic_created_date)
VALUES
  (1, 
  'DeBlasio Birth Certificate', 
  'Who says he was born in NY?!?',
  CURRENT_TIMESTAMP),
  (1,
  'My Nose Itches',
  'and I wish you would be more sympathetic about it.',
  '2015-06-3 13:26:18'),
  (2,
  'I making this thing called FlameWarChest',
  'What do you guys think of it? (be nice)',
  '2015-06-04 03:11:12');


INSERT INTO comments
  (comment_created_date, parent_topic_id, comment_creator_id, comment_content)
VALUES
  ('2015-06-02 05:18:55',2,1,'Well I, dont care!'),
  ('2015-06-03 02:31:04',2,3,'how DARE you, @Ins3rtP3rsonality! Maybe if you had a personality, you would realize this is a SERIOUS ISSUE!!'),
  ('2015-06-03 01:45:01',2,2,'is it true that I can charge my phone using a microwave?'),
  (CURRENT_TIMESTAMP,1,1,'git a job ya hippie!');


INSERT INTO karma
  (voter_id, topic_id, vote_value)
VALUES
  (1,1,1),
  (1,2,1),
  (1,3,-1),
  (3,2,1),
  (3,3,-1),
  (2,1,0);
