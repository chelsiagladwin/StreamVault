CREATE DATABASE `movie_streaming` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

show databases;
use movie_streaming;
show tables;
select * from watchlist;
/* create statements */
create table users (
	user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(100) NOT NULL,
    country VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

create table user_profiles (
    profile_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    profile_name VARCHAR(100) NOT NULL,
    age_limit INT,
		CONSTRAINT fk_user_profiles_user
        FOREIGN KEY (user_id)
        REFERENCES Users(user_id)
        ON DELETE CASCADE
);
create table subscription_plans (
		plan_id int primary key auto_increment, 
		plan_type ENUM('Basic', 'Standard', 'Premium') NOT NULL,
		price decimal (10, 2) not null, 
		duration_days int not null
);

create table user_subscriptions (
    subscription_id int primary key auto_increment,
    user_id int not null,
    plan_id int not null,
    start_date date not null,
    end_date date not null,
    status enum('active', 'expired', 'cancelled') not null,
    auto_renew boolean default false,
    
    constraint fk_user_subscriptions_user
        foreign key (user_id)
        references users(user_id)
        on delete cascade,
        
    constraint fk_user_subscriptions_plan
        foreign key (plan_id)
        references subscription_plans(plan_id)
        on delete cascade
);
create table payments (
	payment_id int primary key auto_increment,
    subscription_id int not null, 
    amount decimal(10,2) not null,
    payment_status enum('pending', 'completed', 'failed', 'refunded') not null,
    payment_date datetime default current_timestamp,
    
    constraint fk_payments_subscription_id
		foreign key (subscription_id)
        references user_subscriptions(subscription_id)
        on delete cascade
);

create table genres (
    genre_id int primary key auto_increment,
    genre_name varchar(100) not null unique
);

create table directors (
    director_id int primary key auto_increment,
    director_name varchar(100) not null unique
);

CREATE TABLE content (
	content_id INT PRIMARY KEY AUTO_INCREMENT,
	title VARCHAR(200) NOT NULL,
	content_type ENUM('movie', 'series') NOT NULL,
	genre_id INT NOT NULL,
	director_id INT,
	release_date DATE,
	duration_minutes INT,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

	CONSTRAINT fk_content_genre
		FOREIGN KEY (genre_id)
		REFERENCES genres(genre_id)
		ON DELETE CASCADE,

	CONSTRAINT fk_content_director
		FOREIGN KEY (director_id)
		REFERENCES directors(director_id)
		ON DELETE SET NULL
); 

create table languages (
    language_id int primary key auto_increment,
    language_name varchar(100) not null unique
);

create table content_languages (
    content_id int,
    language_id int,
    primary key (content_id, language_id),
    foreign key (content_id) references content(content_id) on delete cascade,
    foreign key (language_id) references languages(language_id) on delete cascade
);

create table license (
	license_id int primary key auto_increment,
    content_id int,
    country varchar(200) not null,
    license_start date,
    license_end date,
    
    constraint fk_content_id_license
			foreign key (content_id)
            references content(content_id)
            on delete cascade
);

create table watch_history (
    watch_id int primary key auto_increment,
    profile_id int, 
    content_id int,
    watched_duration int,
    watched_at datetime default current_timestamp,
    completed boolean default false,
    
    constraint fk_content_id_watch
			foreign key (content_id)
            references content(content_id)
            on delete cascade,
            
	constraint fk_profile_id
		foreign key (profile_id)
        references user_profiles(profile_id)
        on delete cascade
);

create table ratings (
    rating_id int primary key auto_increment,
    profile_id int not null,
    content_id int not null,
    rating int not null,
    rated_at datetime default current_timestamp,
    
    constraint chk_rating_range
        check (rating between 1 and 5),
        
    constraint fk_ratings_profile
        foreign key (profile_id)
        references user_profiles(profile_id)
        on delete cascade,
        
    constraint fk_ratings_content
        foreign key (content_id)
        references content(content_id)
        on delete cascade
);

create table watchlist (
    watchlist_id int primary key auto_increment,
    profile_id int not null,
    content_id int not null,
    added_at datetime default current_timestamp,
    
    constraint fk_watchlist_profile
        foreign key (profile_id)
        references user_profiles(profile_id)
        on delete cascade,
        
    constraint fk_watchlist_content
        foreign key (content_id)
        references content(content_id)
        on delete cascade
);
create table active_sessions (
    session_id int primary key auto_increment,
    user_id int not null,
    device_id varchar(100) not null,
    login_time datetime default current_timestamp,
    logout_time datetime,
    
    constraint fk_active_sessions_user
        foreign key (user_id)
        references users(user_id)
        on delete cascade
);

/* insert statements*/
insert into users (user_id, name, email, password_hash, country) values
(1,'arun','arun@mail.com','hash1','india'),
(2,'divya','divya@mail.com','hash2','india'),
(3,'john','john@mail.com','hash3','usa'),
(4,'mia','mia@mail.com','hash4','uk'),
(5,'liam','liam@mail.com','hash5','canada'),
(6,'sara','sara@mail.com','hash6','india'),
(7,'kiran','kiran@mail.com','hash7','india'),
(8,'alex','alex@mail.com','hash8','usa'),
(9,'emma','emma@mail.com','hash9','france'),
(10,'raj','raj@mail.com','hash10','india'); 

insert into user_profiles values
(1,1,'arun_main',18),
(2,2,'divya_main',18),
(3,3,'john_main',18),
(4,4,'mia_main',13),
(5,5,'liam_main',18),
(6,6,'sara_kids',13),
(7,7,'kiran_main',18),
(8,8,'alex_main',18),
(9,9,'emma_main',18),
(10,10,'raj_main',18);

insert into subscription_plans values
(1,'basic',199.00,30),
(2,'standard',399.00,30),
(3,'premium',599.00,30),
(4,'basic',199.00,30),
(5,'standard',399.00,30),
(6,'premium',599.00,30),
(7,'basic',199.00,30),
(8,'standard',399.00,30),
(9,'premium',599.00,30),
(10,'basic',199.00,30);

insert into user_subscriptions values
(1,1,3,'2026-01-01','2026-01-31','active',1),
(2,2,2,'2026-01-10','2026-02-09','active',1),
(3,3,1,'2025-12-01','2025-12-31','expired',0),
(4,4,2,'2026-02-01','2026-03-02','active',1),
(5,5,3,'2026-01-15','2026-02-14','active',1),
(6,6,1,'2025-11-01','2025-11-30','expired',0),
(7,7,2,'2026-01-20','2026-02-19','active',1),
(8,8,3,'2026-01-25','2026-02-24','active',1),
(9,9,2,'2026-01-05','2026-02-04','cancelled',0),
(10,10,1,'2025-10-01','2025-10-31','expired',0);

insert into payments values
(1,1,599.00,'completed','2026-01-01'),
(2,2,399.00,'completed','2026-01-10'),
(3,3,199.00,'completed','2025-12-01'),
(4,4,399.00,'completed','2026-02-01'),
(5,5,599.00,'completed','2026-01-15'),
(6,6,199.00,'failed','2025-11-01'),
(7,7,399.00,'completed','2026-01-20'),
(8,8,599.00,'completed','2026-01-25'),
(9,9,399.00,'refunded','2026-01-05'),
(10,10,199.00,'completed','2025-10-01');

insert into genres values
(1,'action'),
(2,'drama'),
(3,'comedy'),
(4,'thriller'),
(5,'sci-fi'),
(6,'romance'),
(7,'horror'),
(8,'documentary'),
(9,'animation'),
(10,'adventure');

insert into directors values
(1,'christopher nolan'),
(2,'steven spielberg'),
(3,'martin scorsese'),
(4,'denis villeneuve'),
(5,'quentin tarantino'),
(6,'james cameron'),
(7,'peter jackson'),
(8,'greta gerwig'),
(9,'ridley scott'),
(10,'ron howard');

insert into content values
(1,'inception','movie',1,1,'2010-07-16',148,'2026-01-01'),
(2,'interstellar','movie',1,1,'2014-11-07',169,'2026-01-01'),
(3,'dunkirk','movie',1,1,'2017-07-21',106,'2026-01-01'),
(4,'avatar 3','movie',5,6,'2026-06-01',180,'2026-01-01'),
(5,'the batman returns','movie',1,9,'2025-09-10',155,'2026-01-01'),
(6,'romantic escape','movie',6,8,'2025-08-01',120,'2026-01-01'),
(7,'space odyssey series','series',5,4,'2024-01-01',50,'2026-01-01'),
(8,'laugh riot','series',3,2,'2025-03-10',30,'2026-01-01'),
(9,'dark crimes','movie',4,3,'2025-12-15',140,'2026-01-01'),
(10,'animated heroes','series',9,7,'2025-05-05',25,'2026-01-01');

insert into languages values 
(1,'english'),
(2,'spanish');

insert into content_languages values
(1,1),
(1,2),
(2,1),
(2,2),
(3,1),
(4,1),
(4,2),
(5,1),
(6,1),
(7,1);

insert into license values
(1,1,'india','2025-01-01','2026-12-31'),
(2,2,'india','2025-01-01','2026-12-31'),
(3,3,'usa','2025-01-01','2026-12-31'),
(4,4,'india','2025-01-01','2026-12-31'),
(5,5,'uk','2025-01-01','2026-12-31'),
(6,6,'india','2025-01-01','2026-12-31'),
(7,7,'usa','2025-01-01','2026-12-31'),
(8,8,'india','2025-01-01','2026-12-31'),
(9,9,'france','2025-01-01','2026-12-31'),
(10,10,'india','2025-01-01','2026-12-31');

insert into watch_history (profile_id,content_id,watched_duration,completed) values
(1,1,148,true),
(1,2,100,false),
(2,1,148,true),
(2,3,106,true),
(3,2,169,true),
(4,5,155,true),
(5,4,120,false),
(6,8,30,true),
(7,9,140,true),
(8,7,50,false);

insert into ratings (profile_id,content_id,rating) values
(1,1,5),
(1,2,4),
(2,1,5),
(2,3,4),
(3,2,5),
(4,5,3),
(5,4,4),
(6,8,2),
(7,9,5),
(8,7,3);

insert into watchlist (profile_id,content_id) values
(1,3),
(1,5),
(2,2),
(3,1),
(4,6),
(5,1),
(6,7),
(7,2),
(8,9),
(9,4);

insert into active_sessions (user_id,device_id,login_time,logout_time) values
(1,'mobile_01','2026-05-01 10:00:00',null),
(2,'laptop_02','2026-05-01 11:00:00','2026-05-01 12:00:00'),
(3,'mobile_03','2026-05-02 09:00:00',null),
(4,'tv_04','2026-05-02 10:00:00',null),
(5,'mobile_05','2026-05-02 12:00:00','2026-05-02 13:00:00'),
(6,'laptop_06','2026-05-03 08:00:00',null),
(7,'mobile_07','2026-05-03 09:30:00',null),
(8,'tablet_08','2026-05-03 10:15:00',null),
(9,'mobile_09','2026-05-04 11:00:00','2026-05-04 12:00:00'),
(10,'tv_10','2026-05-04 13:00:00',null);

/* Task - Solutions */

/* Retrieve a list of all movies and TV shows available in the 'Action' category. */
select title, content_type, genre_name 
from  content c
join genres g ON c.genre_id = g.genre_id
where g.genre_name = 'action';

/* List all registered users along with their current subscription plan (Basic, Standard, Premium)*/
select u.user_id, u.name, sp.plan_type
from users u
left join user_subscriptions us on u.user_id = us.user_id and us.status = 'Active'
left join subscription_plans sp on us.plan_id = sp.plan_id;

/* Find the most-watched movie of the last three months. */
select content_id, COUNT(*) AS view_count
from watch_history
where watched_at >= '2026-02-14'
group by content_id
order by view_count DESC
limit 2;

/* List all movies directed by 'Christopher Nolan' available on the platform */
select c.content_id, c.title, d.director_name
from content c
left join directors d
on c.director_id = d.director_id where director_name = 'christopher nolan' and content_type = 'movie';

/* Retrieve the watch history of a specific user, including movie titles and timestamps. */
select up.profile_name, c.title, wh.watched_at, wh.watched_duration
from watch_history wh
join content c on wh.content_id = c.content_id
join user_profiles up on wh.profile_id = up.profile_id
where up.user_id = 1
order by wh.watched_at desc;

/* Find users who have rated at least five movies and calculate their average rating score. */
select profile_id, COUNT(*) as total_ratings, avg(rating) as avg_rating
from ratings
group by profile_id
having COUNT(*) = 5;

/* Identify users who have watched more than 20 hours of content in the past month. */
select profile_id, SUM(watched_duration) as total_minutes
from watch_history
where watched_at >= '2026-04-13'
group by profile_id
having total_minutes > 1200;

/* Retrieve all upcoming movies set to be released on the platform within the next six months. */
select title, content_type, release_date 
from content 
where release_date between '2026-05-13' and DATE_ADD('2026-05-13', interval 6 month)
order by release_date asc;

/* Retrieve all upcoming movies set to be released on the platform within the next six months. */
SELECT c.title
FROM content_languages cl
JOIN content c ON cl.content_id = c.content_id
JOIN languages l ON cl.language_id = l.language_id
WHERE l.language_name IN ('english', 'spanish') AND c.content_type = 'movie'
GROUP BY c.content_id, c.title
HAVING COUNT(DISTINCT l.language_name) = 2;

/* Identify movies that have been rated below 3 stars by more than 50 users. */
SELECT c.title, COUNT(r.rating_id) AS low_rating_count
FROM ratings r
JOIN content c ON r.content_id = c.content_id
WHERE r.rating < 3 AND c.content_type = 'movie'
GROUP BY c.content_id, c.title
HAVING COUNT(r.rating_id) > 50;

/* Retrieve subscription renewal dates for all users with active plans. */
SELECT u.name, u.email, us.end_date AS renewal_date
FROM user_subscriptions us
JOIN users u ON us.user_id = u.user_id
WHERE us.status = 'active' AND us.auto_renew = 1;

/* Find users who have added at least five movies to their watchlist but haven't watched any. */
SELECT profile_id 
FROM watchlist
WHERE profile_id NOT IN (SELECT profile_id FROM watch_history)
GROUP BY profile_id
HAVING COUNT(*) >= 5;

/*List the top 5 directors whose movies have received the highest average ratings.*/
SELECT director_id, AVG(rating) AS avg_rating
FROM ratings r
JOIN content c ON r.content_id = c.content_id
GROUP BY director_id
ORDER BY avg_rating DESC
LIMIT 5;

/*Find all subscription cancellations that occurred in the last six months and analyze trends.*/
SELECT DATE_FORMAT(end_date, '%Y-%m') AS cancellation_month, COUNT(*) AS total_cancellations
FROM user_subscriptions
WHERE status = 'cancelled' AND end_date >= DATE_SUB('2026-05-13', INTERVAL 6 MONTH)
GROUP BY cancellation_month
ORDER BY cancellation_month DESC;

/*Identify users who started but did not complete at least three movies.*/
SELECT up.user_id, up.profile_name, COUNT(wh.watch_id) AS incomplete_movies
FROM watch_history wh
JOIN content c ON wh.content_id = c.content_id AND c.content_type = 'movie'
JOIN user_profiles up ON wh.profile_id = up.profile_id
WHERE wh.completed = 0
GROUP BY up.profile_id, up.profile_name, up.user_id
HAVING COUNT(wh.watch_id) >= 3;

/* Generate a report showing revenue generated from subscriptions in the last year.*/
SELECT DATE_FORMAT(payment_date, '%Y-%m') AS payment_month, SUM(amount) AS total_revenue
FROM payments
WHERE payment_status = 'completed' AND payment_date >= DATE_SUB('2026-05-13', INTERVAL 1 YEAR)
GROUP BY payment_month
ORDER BY payment_month DESC;

/* Ensure that when a user cancels their subscription, their access is revoked immediately. */
UPDATE user_subscriptions 
SET status = 'cancelled', auto_renew = 0, end_date = CURRENT_DATE 
WHERE user_id = 1 AND status = 'active';

/* Prevent users from watching movies that are not available in their geographic region. */
SELECT COUNT(*) 
FROM users u
JOIN license l ON l.content_id = 1 
WHERE u.user_id = 1                
  AND LOWER(u.country) = LOWER(l.country)
  AND CURRENT_DATE BETWEEN l.license_start AND l.license_end;

/* Ensure that when a new movie is added, its genre, director, and release year are correctly recorded. */
INSERT INTO content VALUES
(11,'New Movie','movie',1,1,'2010-07-16',148,'2026-01-01');

/* Update a user's subscription status immediately when they successfully complete a payment. */
UPDATE user_subscriptions 
SET status = 'active', start_date = CURRENT_DATE, end_date = DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY)
WHERE subscription_id = 1;

/* Identify users who have shared their login credentials with multiple devices simultaneously. */
SELECT user_id, COUNT(session_id) AS open_sessions 
FROM active_sessions 
WHERE logout_time IS NULL 
GROUP BY user_id HAVING COUNT(session_id) > 1;

/* Ensure that only verified content creators can upload and modify movies or TV shows. */
SELECT user_id FROM user_subscriptions WHERE status = 'active' AND end_date = DATE_ADD(CURRENT_DATE, INTERVAL 3 DAY);

/* Trigger a notification when a user's subscription is about to expire within 3 days. */
CREATE EVENT trigger_expiry_notifications
ON SCHEDULE EVERY 1 DAY
STARTS '2026-05-15 00:00:00'
DO
  INSERT INTO system_notifications (user_id, message, created_at)
  SELECT user_id, 'Your subscription will expire in 3 days! Renew now.', NOW()
  FROM user_subscriptions
  WHERE status = 'active' 
    AND end_date = DATE_ADD(CURRENT_DATE, INTERVAL 3 DAY);
    
/* Automatically recommend similar movies based on a user's watch history and ratings. */
SELECT c.content_id, c.title, AVG(r.rating) AS community_score
FROM content c
JOIN ratings r ON c.content_id = r.content_id
WHERE c.content_type = 'movie'
  AND c.genre_id IN (
      SELECT DISTINCT genre_id 
      FROM content c2
      JOIN ratings r2 ON c2.content_id = r2.content_id
      WHERE r2.profile_id = 1 AND r2.rating >= 4
  )
GROUP BY c.content_id, c.title
ORDER BY community_score DESC;

/* Generate a monthly report summarizing user activity, most-watched genres, and revenue trends */
SELECT 	
    DATE_FORMAT(p.payment_date, '%Y-%m') AS report_month,
    SUM(p.amount) AS total_revenue,
    COUNT(DISTINCT us.user_id) AS paying_users,
    (
    SELECT COUNT(*) FROM watch_history WHERE DATE_FORMAT(watched_at, '%Y-%m') = report_month
    ) AS total_videos_watched,
    (
    SELECT COUNT(DISTINCT user_id) FROM active_sessions WHERE DATE_FORMAT(login_time, '%Y-%m') = report_month
    ) AS monthly_active_profiles,
    
    (
    SELECT c.genre_id 
     FROM watch_history wh 
     JOIN content c ON wh.content_id = c.content_id 
     WHERE DATE_FORMAT(wh.watched_at, '%Y-%m') = report_month
     GROUP BY c.genre_id 
     ORDER BY COUNT(*) DESC 
     LIMIT 1
     ) AS top_performing_genre_id
FROM payments p
JOIN user_subscriptions us ON p.subscription_id = us.subscription_id
WHERE p.payment_status = 'completed'
GROUP BY report_month
ORDER BY report_month DESC;

use movie_streaming;