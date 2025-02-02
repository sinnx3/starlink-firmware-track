DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS users_password_reset;
DROP TABLE IF EXISTS users_api_keys;
DROP TABLE IF EXISTS firmware;
DROP TABLE IF EXISTS speedtests;
DROP TABLE IF EXISTS speedtest_stats;

CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT UNIQUE NOT NULL,
  username TEXT UNIQUE,
  password TEXT NOT NULL,
  totp TEXT,
  role TEXT,
  time_zone TEXT,
  activated BOOLEAN,
  discord_id TEXT
);

CREATE TABLE users_password_reset (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  reset_key TEXT UNIQUE NOT NULL,
  date_time TEXT NOT NULL,
  activated BOOLEAN NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE TABLE users_api_keys (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  key TEXT UNIQUE NOT NULL,
  date_time TEXT NOT NULL,
  source TEXT NOT NULL,
  name TEXT NOT NULL,
  use_counter INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE TABLE firmware (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  date_added TEXT NOT NULL,
  type TEXT NOT NULL,
  version_info TEXT NOT NULL,
  reddit_thread TEXT
);

CREATE TABLE speedtests (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  date_added TEXT NOT NULL,
  date_run TEXT NOT NULL,
  url TEXT NOT NULL,
  country TEXT,
  server TEXT,
  latency DECIMAL,
  download DECIMAL,
  upload DECIMAL,
  source TEXT,
  distance INTEGER,
  user_id INTEGER,
  FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE TABLE speedtest_stats (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  region TEXT NOT NULL,
  date_calculated TEXT,
  -- Day
  day_count INTEGER,
  day_latency_avg DECIMAL,
  day_latency_max DECIMAL,
  day_latency_min DECIMAL,
  day_download_avg DECIMAL,
  day_download_max DECIMAL,
  day_download_min DECIMAL,
  day_upload_avg DECIMAL,
  day_upload_max DECIMAL,
  day_upload_min DECIMAL,
  -- Week
  week_count INTEGER,
  week_latency_avg DECIMAL,
  week_latency_max DECIMAL,
  week_latency_min DECIMAL,
  week_download_avg DECIMAL,
  week_download_max DECIMAL,
  week_download_min DECIMAL,
  week_upload_avg DECIMAL,
  week_upload_max DECIMAL,
  week_upload_min DECIMAL,
  -- Month
  month_count INTEGER,
  month_latency_avg DECIMAL,
  month_latency_max DECIMAL,
  month_latency_min DECIMAL,
  month_download_avg DECIMAL,
  month_download_max DECIMAL,
  month_download_min DECIMAL,
  month_upload_avg DECIMAL,
  month_upload_max DECIMAL,
  month_upload_min DECIMAL,
  -- Year
  year_count INTEGER,
  year_latency_avg DECIMAL,
  year_latency_max DECIMAL,
  year_latency_min DECIMAL,
  year_download_avg DECIMAL,
  year_download_max DECIMAL,
  year_download_min DECIMAL,
  year_upload_avg DECIMAL,
  year_upload_max DECIMAL,
  year_upload_min DECIMAL,
  -- All
  all_count INTEGER,
  all_latency_avg DECIMAL,
  all_latency_max DECIMAL,
  all_latency_min DECIMAL,
  all_download_avg DECIMAL,
  all_download_max DECIMAL,
  all_download_min DECIMAL,
  all_upload_avg DECIMAL,
  all_upload_max DECIMAL,
  all_upload_min DECIMAL
);