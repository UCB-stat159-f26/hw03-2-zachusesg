check_career_data <- function(career_data) {
  needed <- c("player_age", "age_diff", "result", "player")
  if (!is.data.frame(career_data) || !all(needed %in% names(career_data))) {
    stop("`career_data` must be a data frame returned by get_career_matches().",
         call. = FALSE)
  }
}

#' Plot a tennis player's career matches
#'
#' Scatter plot of the player's age against the age difference with each
#' opponent, colored by whether the player won or lost.
#'
#' @param career_data A data frame returned by [get_career_matches()].
#' @return A ggplot object.
#' @examples
#' \dontrun{
#' serena <- get_career_matches("serena williams")
#' plot_career_matches(serena)
#' }
#' @importFrom ggplot2 .data
#' @export
plot_career_matches <- function(career_data) {
  check_career_data(career_data)
  wins <- sum(career_data$result == "W")
  losses <- sum(career_data$result == "L")
  ggplot2::ggplot(career_data, ggplot2::aes(x = .data$player_age, y = .data$age_diff,
                                            color = .data$result)) +
    ggplot2::geom_hline(yintercept = 0, linetype = "dashed", color = "gray50") +
    ggplot2::geom_point(alpha = 0.6, size = 1.8) +
    ggplot2::scale_color_manual(values = c(W = "#1b9e77", L = "#d95f02"),
                                breaks = c("W", "L"), labels = c("Won", "Lost")) +
    ggplot2::labs(title = paste0(career_data$player[1], "'s Professional Matches"),
                  subtitle = paste0(wins, " wins and ", losses, " losses"),
                  x = "Player's age (years)", y = "Player's age minus opponent's age (years)",
                  color = NULL, caption = "Data: Tennis Abstract (Jeff Sackmann)") +
    ggplot2::theme_bw(base_size = 12) +
    ggplot2::theme(plot.title = ggplot2::element_text(face = "bold"),
                   legend.position = "top", panel.grid.minor = ggplot2::element_blank())
}
