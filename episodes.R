# EPISODES.R
#
# This script uses the Spotify API to create a list of Armchair Expert episodes.
#
# Ben Davies
# September 2022


# Initialization ----

# Load packages
library(bldr)
library(dplyr)
library(httr)
library(jsonlite)
library(readr)
library(yaml)

# Initialize cache
cache_dir = 'episodes/'
if (!dir.exists(cache_dir)) dir.create(cache_dir)


# API requests ----

# Import credentials
credentials = read_yaml('credentials.yaml')

# Authenticate
token = oauth2.0_token(
  endpoint = oauth_endpoint(
    request = NULL,
    authorize = 'https://accounts.spotify.com/authorize',
    access = 'https://accounts.spotify.com/api/token'
  ),
  app = oauth_app('spotify', credentials$client_id, credentials$secret),
  as_header = T
)

# Download episode data
i = 0
done = F
while (!done) {
  
  # Send GET request
  req = GET(
    url = paste0(
      'https://api.spotify.com/v1',
      '/shows/',
      '6kAsbP8pxwaU2kPibKTuHE',
      '/episodes'
    ),
    config = token,
    query = list(limit = 50, offset = i)
  ) %>%
    content(as = 'parsed')
  
  # Iterate over episodes
  for (episode in req$items) {
    
    # Initialize cache
    episode_cache_dir = paste0(
      cache_dir,
      sub('([0-9]{4})-([0-9]{2}).*', '\\1/\\2/', episode$release_date)
    )
    if (!dir.exists(episode_cache_dir)) dir.create(episode_cache_dir, recursive = T)
    
    # Save data to cache
    episode_cache_path = paste0(episode_cache_dir, episode$id, '.json')
    if (!file.exists(episode_cache_path)) {
      episode %>%
        toJSON(auto_unbox = T, pretty = T) %>%
        write_lines(episode_cache_path)
    }
    
  }
  
  # Count cached episodes
  n_cached_episodes = cache_dir %>%
    dir(pattern = '[.]json', recursive = T) %>%
    length()
  
  # Increase offset
  i = i + 50
  
  # Check stopping condition
  if (n_cached_episodes == req$total | i >= req$total) {
    done = T
  }
  
  # Pause
  Sys.sleep(3)

}


# Data collation and export ----

# Iterate over years
years = list.dirs(cache_dir, full.names = F, recursive = F)
for (year in years) {
  
  # List cached files
  files = dir(paste0(cache_dir, '/', year), full.names = T, recursive = T)
  
  # Combine cached files
  cache_path = paste0(cache_dir, year, '.csv')
  if (!file.exists(cache_path) | max(file.mtime(files)) > file.mtime(cache_path)) {
    files %>%
      lapply(read_json) %>%
      lapply(\(x) {
        tibble(
          id = x$id,
          date = x$release_date,
          title = x$name,
          duration = round(x$duration_ms / 1e3),
          description = x$description
        )
      }) %>%
      bind_rows() %>%
      arrange(date) %>%
      write_csv(cache_path)
  }
}

# Define function for replacing non-ASCII characters with ASCII equivalents
replace_non_ascii = function(s) {
  subfun = function(x, pattern, y) gsub(pattern, y, x, perl = TRUE)
  s %>%
    subfun('’', '\'') %>%
    subfun('“', '"') %>%
    subfun('”', '"') %>%
    subfun('…', '...') %>%
    subfun('–', '-') %>%
    subfun(' |​', ' ')
}

# List bonus episode IDs
bonus_ids = c(
  '0uINgYvOn1sWNw7COXFkih',  # BONUS: Malcolm Gladwell
  '1SGO25Ikj9GkWKyxhN7WUw',  # Day 7
  '0n0H8I7FPlaP1yYPsRoOES',  # Celebrating the GOAT GOD
  '3u74UmGJkDpSwepsRcCCcB',  # Bill Gates Book Talk
  '2wHvspaasccybD3ezCTdLb',  # Bonus: Armchair Stories
  '4vleawhXG7g3QihtAfd08G'   # Father's Day
)

# Combine yearly episode lists
episodes = dir(cache_dir, pattern ='[.]csv', full.names = T, recursive = F) %>%
  lapply(read_csv, show_col_types = F) %>%
  bind_rows() %>%
  filter(!grepl('Nurture vs Nurture', title)) %>%
  filter(!grepl('Teaser', title)) %>%
  mutate(across(c(title, description), replace_non_ascii),
         description = sub('Learn more.*adchoices$', '', description),
         description = trimws(gsub('[ ]+', ' ', description)),
         show = case_when(
           grepl('Armchair Anonymous', title) ~ 'Armchair Anonymous',
           grepl('Armchaired & Dangerous', title) ~ 'Armchaired & Dangerous',
           grepl('Flightless Bird', title) ~ 'Flightless Bird',
           grepl('Monica (and|&) Jess', title) ~ 'Monica & Jess Love Boys',
           grepl('Race to 270', title) ~ 'Race to 270',
           grepl('Race to 35', title) ~ 'Race to 35',
           grepl('Synced', title) ~ 'Synced',
           grepl('We are supported by', title, ignore.case = T) ~ 'We Are Supported By...',
           T ~ NA
        ),
        series = case_when(
          id %in% bonus_ids ~ 'Bonus',
          show %in% c('Armchair Anonymous', 'Armchaired & Dangerous', NA) ~ 'Main',
          grepl('^Introducing', title) ~ 'Intro',
          T ~ show
        )) %>%
  arrange(date, show, duration) %>%
  group_by(series) %>%
  mutate(number = ifelse(series %in% c('Bonus', 'Intro'), NA, row_number())) %>%
  ungroup() %>%
  select(id, date, title, show, number, duration, description)

# Save episode list
write_csv(episodes, 'episodes.csv', na = '')


# Session info ----

# Save session info
save_session_info('episodes.log')
