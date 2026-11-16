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

Names can be written as "serena williams", "Serena Williams", or "SerenaWilliams" as the code will correctly read and assign all variations of casing and spacing.

## Functions

- `get_career_matches(player)` this helps return a data frame with one row per match, including:
  date, tournament, opponent, result (W/L), score, player_age, opponent_age,
  age_diff (player minus opponent), and player.
- `plot_career_matches(career_data)` while this returns a ggplot scatter plot of player_age against age_diff, which is colored on win or loss.

## How it works

The package first downloads `jsmatches/<Name>Career.js` and parses its match array. Women's files will list each opponent's birth date, while men's files list the opponent's age directly, so the package first needs to detect which kind of file it has. A player's own birth date is read from their profile page (`wplayer.cgi` for women, and standardized as `player.cgi` for men). Walkovers and matches with missing ages are dropped as they hold insufficient data.

## Tests

Tests take part in use small mock JS files, so they never contact tennisabstract.com itself, can be called with:

    devtools::test()

## Known limitation

The `<Name>Career.js` files only cover a player's older matches. Any recent matches get stored in a separate `<Name>.js` file, so plots will stop before the end of a career (as an example, Rafael Nadal's stops around 2016).

## Reflections

So doing this HW project and working on this package helped enlighten me to how building on a data project has the brunt of the work come from the data source itself. Initially it was easy to assume our career files would include all information needed, but as I know now that was not the case, missing even a player's own birth date, which needed to get traced in the page's scripts and located on the player profile pages, again with wplayer.cgi for women and player.cgi for men. There's even notation differences by gender that isn't standardized, like how opponent information on birth dates vs ages is stored differently, which stopped a universal function from working, and rather needed to have a function know which file it was speaking to ahead of time. We reference Rafael Nadal's plot when stopping around age 30 as a healthy baseline for the "career" file not actually showing a whole career, so important to double check the work and not just rely on file names!

then using my same HW2 scripts into a pakcage made me approach a new aspect of coding in a way i didn't befor,e specifially structuuring my code. Haaving a 20-line limit meant i needed way more smaller helper fucntions, which did at least intuitively make testing each section of my script easier on where it was breaking. One other enat trick I evolved with were norm package conventions, I'm thinking things such as documenting with roxygen comments, and using @export to decide which functions users can see.

Lastly, testing is the waekest area of expertise of my work so pushing for it more here helped me design a funciton with implementation both online and offline, and what that looks like. We know the website changes and can go offline, so a test with a smaller pool of mock files instead of live downloads works best, with a function building the data frame the birth date as an argument so it could be tested without the internet. Maybe as next steps, these would merge in the seperate recent-matches file so plots cover the whole time of someone's true career.