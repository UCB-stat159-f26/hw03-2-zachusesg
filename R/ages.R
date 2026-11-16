years_between <- function(from, to) {
  as.numeric(to - from) / 365.25
}

opponent_ages <- function(opponent_field, match_dates) {
  if (is_female_file(opponent_field)) {
    return(years_between(as.Date(opponent_field, "%Y%m%d"), match_dates))
  }
  suppressWarnings(as.numeric(opponent_field))
}

build_career_data <- function(rows, player_dob) {
  dates <- as.Date(extract_field(rows, 1), "%Y%m%d")
  player_age <- years_between(player_dob, dates)
  opponent_age <- opponent_ages(extract_field(rows, 17), dates)
  data <- data.frame(date = dates, tournament = extract_field(rows, 2),
                     opponent = extract_field(rows, 12), result = extract_field(rows, 5),
                     score = extract_field(rows, 10), player_age = player_age,
                     opponent_age = opponent_age, age_diff = player_age - opponent_age)
  keep <- !is.na(data$age_diff) & data$result %in% c("W", "L") & !grepl("W/O", data$score)
  data <- data[keep, ]
  rownames(data) <- NULL
  data
}
