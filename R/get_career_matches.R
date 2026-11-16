#' Get a tennis player's career matches
#'
#' Downloads a player's career matches from tennisabstract.com and returns
#' a data frame with the player's age and the age difference with each opponent.
#'
#' @param player Player name, e.g. "serena williams", "Serena Williams",
#'   or "SerenaWilliams".
#' @return A data frame with one row per match: date, tournament, opponent,
#'   result (W or L), score, player_age, opponent_age, age_diff, and player.
#' @examples
#' \dontrun{
#' serena <- get_career_matches("serena williams")
#' }
#' @export
get_career_matches <- function(player) {
  player_id <- format_player_name(player)
  rows <- parse_career_js(download_career_js(player_id))
  female <- is_female_file(extract_field(rows, 17))
  player_dob <- get_player_dob(player_id, female)
  data <- build_career_data(rows, player_dob)
  data$player <- gsub("([a-z])([A-Z])", "\\1 \\2", player_id)
  data
}
