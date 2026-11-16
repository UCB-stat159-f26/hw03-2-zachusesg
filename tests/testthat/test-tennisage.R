female_js <- r"(var morematchmx = [["19951030", "Canadian Open", "Carpet", "W", "L", "", "", "WC", "Q1", "6-1 6-1", "3", "Anne Miller", "149", "7", "", "R", "19770119", "", "USA", "0", "", "", "", "", "", "", "1995-W-WT-CAN-02A-1995-013"],
  ["19970307", "Indian Wells", "Hard", "W", "L", "", "", "WC", "Q1", "6-4 6-0", "3", "Alexia Dechaume Balleret", "87", "", "", "R", "19700503", "", "FRA", "0", "", "", "", "", "", "", "1997-W-WT-USA-02A-1997-006"]])"

male_js <- r"(var morematchmx = [["20010910", "Spain F10", "Hard", "S", "L", "", "", "WC", "R32", "2-6 7-5 6-2", "3", "Guillermo Platel", "731", "", "", "R", "22.264202601", "", "ESP", "0", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "2001-M-FU-ESP-10A-2001-002", "", "1", "1"],
  ["20010917", "Seville CH", "Clay", "C", "W", "", "", "WC", "R32", "6-4 6-4", "3", "Israel Matos Gil", "751", "", "Q", "U", "18.7597535934", "", "ESP", "0", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "2001-784-015", "", "1", "1"]])"

test_that("player names are formatted for tennisabstract URLs", {
  expect_equal(format_player_name("serena williams"), "SerenaWilliams")
  expect_equal(format_player_name("Serena Williams"), "SerenaWilliams")
  expect_equal(format_player_name("SerenaWilliams"), "SerenaWilliams")
  expect_error(format_player_name(c("a", "b")))
})

test_that("JS files are parsed into match rows", {
  rows <- parse_career_js(female_js)
  expect_length(rows, 2)
  expect_equal(extract_field(rows, 12), c("Anne Miller", "Alexia Dechaume Balleret"))
})

test_that("female and male files are told apart", {
  expect_true(is_female_file(extract_field(parse_career_js(female_js), 17)))
  expect_false(is_female_file(extract_field(parse_career_js(male_js), 17)))
})

test_that("ages are computed for female files from birth dates", {
  data <- build_career_data(parse_career_js(female_js), as.Date("1981-09-26"))
  expect_equal(nrow(data), 2)
  expect_equal(data$age_diff[1], -4.684, tolerance = 0.001)
})

test_that("ages are taken directly from male files", {
  data <- build_career_data(parse_career_js(male_js), as.Date("1986-06-03"))
  expect_equal(data$opponent_age, c(22.264202601, 18.7597535934))
  expect_equal(data$result, c("L", "W"))
})

test_that("plot function returns a ggplot and rejects bad input", {
  data <- build_career_data(parse_career_js(female_js), as.Date("1981-09-26"))
  data$player <- "Serena Williams"
  expect_s3_class(plot_career_matches(data), "ggplot")
  expect_error(plot_career_matches(data.frame(x = 1)))
})
