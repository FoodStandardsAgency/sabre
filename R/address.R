#' Find postcodes in a string.
#'
#' Returns an empty string where no match is found.
#' The string can be an address or any text string.
#' For large flat files, use `find_postcodes()`.
#'
#' @param string Input vector. Either a character vector, or something
#'   coercible to one (e.g. a data frame).
#' @param locale A string, the country code in format ISO 3. Default is "GBR".
#'
#' @return A character vector containing all the matches.
#' @seealso [find_postcodes()]
#' @export
#'
#' @section TODO:
#' Handle extra white spaces: try trimming ws inside postcode if not match
#' Handle special cases with lower casing without interferring with other strings
#'   such as Ec2M 1aA
#'
#' @examples
#' string <- "The quick brown fox lives at 6 Bridge Road, N17 0RN."
#' find_postcodes_in_string(string)
#'
#' @importFrom stringr str_extract_all
find_postcodes_in_string <- function(string, locale = "GBR") {
  # @TODO
  switch(locale,
         "GBR" = {
           postcode_pattern <- paste0(
             "(\\b[A-Z]{1,2}\\d[A-Z\\d]?|",    # district preceded by word
             "\\w{0}[A-Z]{1,2}\\d[A-Z\\d]?) ", # district preceded by word with no ws
             "?\\d[A-Z]{2}"                    # sector + unit
           )
         })

  string %>%
    str_extract_all(., postcode_pattern) %>%
    unlist()
}


#' Find postcodes in a list, vector or data frame of strings/addresses.
#'
#' Returns an empty string where no match is found.
#' Vectorized version of `find_postcodes_in_string()`.
#'
#' @param X list, vector or data frame, appropriate to a call to lapply
#' @param ... optional arguments to `find_postcodes_in_string()`.
#'
#' @return list
#' @seealso [find_postcodes_in_string()]
#' @export
#'
#' @examples
#' find_postcodes(businesses)
find_postcodes <- function(X, ...) {
  lapply(X, find_postcodes_in_string)
}


#' Find the numerical parts of an address (building|house|unit).
#'
#' Returns an empty string where no match is found.
#' The match is performed with a look ahead to match address number patterns
#'   that are not a postcode.
#' For large flat files, use `find_buildings_numbers()`.
#'
#' @param string Input vector. Either a character vector, or something
#'   coercible to one (e.g. a data frame).
#' @param locale A string, the country code in format ISO 3. Default is "GBR".
#' @param sep A character string to separate the terms in the returned string.
#'
#' @return A character vector of the contatenated values (shape: (1,1)).
#' @seealso [find_buildings_numbers()]
#' @export
#'
#' @examples
#' string <- "The quick brown fox's family lives at 22A-22B Bridge Road, N17 0RN."
#' find_buildings_numbers_in_string(string)
#'
#' @importFrom stringr str_c
find_buildings_numbers_in_string <- function(string, locale = "GBR", sep = "|") {
  switch(locale,
         "GBR" = {
           numbers_pattern <- paste0(
             "(?![a-zA-Z]{1,2}\\d[a-zA-Z\\d]?)",
             "(?!\\d[a-zA-Z]{2})\\b",
             "([0-9]+[a-zA-Z]?)\\b",
             "|\\b\\d+(?=[a-zA-Z]{3,}\\b)"
           )
         })

  string %>%
    toupper() %>%
    str_extract_all(., numbers_pattern) %>%
    unlist() %>%
    str_c(., collapse = sep)
}


#' Find the numerical parts (building|house|unit) in a list, vector or data
#' frame of addresses.
#'
#' Returns an empty string where no match is found.
#' Vectorized version of `find_buildings_numbers_in_string()`.Doest not match
#' postcodes or parts of a postcode.
#'
#' @param X list, vector or data frame, appropriate to a call to lapply.
#' @param ... optional arguments to `find_buildings_numbers_in_string()`.
#'
#' @return list
#' @seealso [find_buildings_numbers_in_string()]
#' @export
#'
#' @examples
#' find_buildings_numbers(businesses)
find_buildings_numbers <- function(X, ...) {
  lapply(X, find_buildings_numbers_in_string)
}


#' Strip buildings numbers (building|house|unit)
#'
#' @param string Input vector. Either a character vector, or something
#'   coercible to one (e.g. a data frame).
#' @param locale A string, the country code in format ISO 3. Default is "GBR".
#'
#' @return A character vector of the original character strings striped from
#'   building numbers.
#' @seealso [strip_buildings_numbers()]
#' @export
#'
#' @examples
#'strip_buildings_numbers_in_string(businesses[['address']])
#'
#' @importFrom stringr str_replace_all str_squish
strip_buildings_numbers_in_string <- function(string, locale = "GBR") {
  switch(locale,
         "GBR" = {
           numbers_pattern <- paste0(
             "(?![a-zA-Z]{1,2}\\d[a-zA-Z\\d]?)",
             "(?!\\d[a-zA-Z]{2})\\b",
             "([0-9]+[a-zA-Z]?)\\b",
             "|\\b\\d+(?=[a-zA-Z]{3,}\\b)"
           )
         })

  string %>%
    str_replace_all(., numbers_pattern, "") %>%
    str_squish() # if string start or end with number, creates trailing ws
}


#' Strip buildings numbers (building|house|unit) from a list, vector or data
#' frame of addresses.
#'
#' @param X list, vector or data frame, appropriate to a call to lapply
#' @param ... optional arguments to `find_buildings_numbers_in_string()`.
#'
#' @return list
#' @seealso [strip_buildings_numbers_in_string()]
#' @export
#'
#' @examples
#' strip_buildings_numbers(businesses)
strip_buildings_numbers <- function(X, ...) {
  lapply(X, strip_buildings_numbers_in_string)
}


#' Reformat a postcode to standards.
#'
#' For GBR postcodes, if it is missing a white space between the outward
#' (area + district) and inward (sector + unit) codes, then add it.
#'
#' @param postcode A character string.
#' @param locale A string, the country code in format ISO 3. Default is "GBR".
#'
#' @return A character string.
#' @export
#'
#' @examples
#' format_postcode('eC2A0Rn')
#'
#' @importFrom stringr str_squish
format_postcode  <- function(postcode, locale = "GBR") {
  switch(locale,
         "GBR" = {
           postcode_pattern <- "([A-Z]{1,2}\\d[A-Z\\d]?)(\\d[A-Z]{2})"
         })

  postcode <- str_squish(postcode) %>%
    toupper()

  if (!grepl(" ", postcode, fixed = TRUE)) {
    gsub(postcode_pattern, '\\1 \\2', postcode, perl = TRUE)
  } else {
    postcode
  }
}
