#' Armchair Expert episodes
#'
#' Data frame containing data on \href{https://armchairexpertpod.com}{Armchair Expert} podcast episodes.
#'
#' @docType data
#'
#' @usage data(episodes)
#'
#' @format Data frame with columns
#' \describe{
#' \item{id}{Episode ID on Spotify}
#' \item{date}{Episode release date (in YYYY-MM-DD format)}
#' \item{title}{Episode title}
#' \item{show}{Show to which episode belongs (\href{https://armchairexpertpod.com/armchair-anonymous}{Armchair Anonymous}, \href{https://armchairexpertpod.com/armchaired-dangerous}{Armchaired & Dangerous}, \href{https://armchairexpertpod.com/flightless-bird}{Flightless Bird}, \href{https://armchairexpertpod.com/monica-jess-love-boys}{Monica & Jess Love Boys}, \href{https://armchairexpertpod.com/race-to-270}{Race to 270}, Race to 35, \href{https://armchairexpertpod.com/synced}{Synced}, \href{https://armchairexpertpod.com/we-are-supported-by}{We Are Supported By...}, or \href{https://armchairexpertpod.com/yearbook}{Yearbook}), if applicable}
#' \item{number}{Within-show episode number, if applicable}
#' \item{duration}{Episode length (in seconds)}
#' \item{description}{Episode description}
#' }
#'
#' @examples
#' episodes
#'
#' if (require("dplyr")) {
#' episodes %>% count(show)
#' }
#'
#' @source \href{https://developer.spotify.com/documentation/web-api}{Spotify API}
"episodes"
