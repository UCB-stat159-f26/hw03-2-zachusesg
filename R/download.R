base_url <- "https://www.tennisabstract.com/"

format_player_name <- function(player) {
  if (!is.character(player) || length(player) != 1) {
    stop("`player` must be a single name, e.g. \"Serena Williams\".", call. = FALSE)
  }
  words <- strsplit(trimws(player), "\\s+")[[1]]
  if (length(words) == 1) return(words)
  paste0(toupper(substring(words, 1, 1)), substring(words, 2), collapse = "")
}

read_url_text <- function(url) {
  lines <- tryCatch(suppressWarnings(readLines(url, warn = FALSE)),
                    error = function(e) NULL)
  if (is.null(lines)) return(NULL)
  paste(lines, collapse = "\n")
}

download_career_js <- function(player_id) {
  url <- paste0(base_url, "jsmatches/", player_id, "Career.js")
  js_text <- read_url_text(url)
  if (is.null(js_text)) {
    stop("Player \"", player_id, "\" was not found on tennisabstract.com. ",
         "Check the spelling, e.g. \"Serena Williams\".", call. = FALSE)
  }
  js_text
}
