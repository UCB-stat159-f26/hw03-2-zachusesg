@'
# tennisage

This is an R package we're using for STAT 159's HW3 project (Fall 2026, Zacharia Makari). In sum it downloads a tennis player's career matches from tennisabstract.com and plots the player's age against the age difference with each opponent, iterating on the work from HW2 with the NYT Serena Williams graphic.

## Installation

    devtools::install_github("UCB-stat159-f26/hw03-2-zachusesg")

## Usage

    library(tennisage)

    serena <- get_career_matches("serena williams")
    plot_career_matches(serena)

    rafa <- get_career_matches("Rafael Nadal")
    plot_career_matches(rafa)

    get_career_matches("Gaston Sanchez")   # error: player not found

Names can be written as "serena williams", "Serena Williams", or "SerenaWilliams", as the code will correctly read all variations of casing and spacing.

## Functions

- `get_career_matches(player)` returns a data frame with one row per match, including:
  date, tournament, opponent, result (W/L), score, player_age, opponent_age,
  age_diff (player minus opponent), and player.
- `plot_career_matches(career_data)` returns a ggplot scatter plot of player_age against age_diff, colored by win or loss.

## How it works

The package first downloads `jsmatches/<Name>Career.js` and parses its match array. Women's files list each opponent's birth date, while men's files list the opponent's age directly, so the package first needs to detect which kind of file it has. A player's own birth date is read from their profile page (`wplayer.cgi` for women and `player.cgi` for men). Walkovers and matches with missing ages are dropped, as they hold insufficient data.

## Tests

Tests use small mock JS files, so they never contact tennisabstract.com. Run them with:

    devtools::test()

## Known limitation

The `<Name>Career.js` files only cover a player's older matches. Any recent matches get stored in a separate `<Name>.js` file, so plots will stop before the end of a career (as an example, Rafael Nadal's stops around 2016).

## Reflections

Doing this HW project and working on this package helped show me how, in a data project, the brunt of the work comes from the data source itself. Initially it was easy to assume our career files would include all the information needed, but as I know now that was not the case. They were missing even a player's own birth date, which needed to be traced in the page's scripts and located on the player profile pages, with wplayer.cgi for women and player.cgi for men. There are even notation differences by gender that aren't standardized, like how opponent information is stored as birth dates vs. ages, which stopped a universal function from working and instead required a function that knows which file it is reading ahead of time. Rafael Nadal's plot stopping around age 30 is a good example of the "career" file not actually showing a whole career, so it's important to double check the work and not just rely on file names!

Turning my same HW2 scripts into a package made me approach an aspect of coding in a way I didn't before, specifically structuring my code. Having a 20-line limit meant I needed many more small helper functions, which did at least make it more intuitive to test each section of my script and see where it was breaking. Another neat thing I picked up was normal package conventions, such as documenting with roxygen comments and using @export to decide which functions users can see.

Lastly, testing is the weakest area of my work, so pushing for it more here helped me design a function that works both online and offline, and see what that looks like. We know the website changes and can go offline, so testing with a small pool of mock files instead of live downloads works best, with the function that builds the data frame taking the birth date as an argument so it can be tested without the internet. As a next step, I would merge in the separate recent-matches file so plots cover the whole span of a player's career.