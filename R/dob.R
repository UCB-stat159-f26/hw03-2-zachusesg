get_player_dob <- function(player_id, female) {
  page <- if (female) "cgi-bin/wplayer.cgi?p=" else "cgi-bin/player.cgi?p="
  text <- read_url_text(paste0(base_url, page, player_id))
  if (is.null(text)) text <- ""
  dob <- regmatches(text, regexpr("dob = [0-9]{8}", text))
  if (length(dob) == 0) {
    stop("Could not find a birth date for \"", player_id, "\" on tennisabstract.com.", call. = FALSE)
  }
  as.Date(sub("dob = ", "", dob), "%Y%m%d")
}
