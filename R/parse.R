parse_career_js <- function(js_text) {
  start <- regexpr("[", js_text, fixed = TRUE)
  ends <- gregexpr("]", js_text, fixed = TRUE)[[1]]
  array_text <- substr(js_text, start, max(ends))
  jsonlite::fromJSON(array_text, simplifyMatrix = FALSE)
}

extract_field <- function(rows, i) {
  vapply(rows, function(row) {
    if (length(row) < i) return(NA_character_)
    as.character(row[[i]])
  }, character(1))
}

is_female_file <- function(opponent_field) {
  values <- opponent_field[!is.na(opponent_field) & opponent_field != ""]
  all(grepl("^[0-9]{8}$", values))
}
