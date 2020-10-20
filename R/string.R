replacements_ <- list(
  ghbusiness = list(
    from = c(',', '\\(.*\\)', '&'),
    to = c('', '', ' and ')
  )
)


#' Replace (substitutes) patterns in a string.
#'
#' Wrapper of the stringi `stri_replace_` family of functions.
#'
#' Given two vectors mapping the patterns to be replaced with their
#' replacements, return a new string.
#'
#' @param string A character vector.
#' @param from A string vector containing the patterns (regex, as string) to be
#'   matched.
#' @param to A string vector of the replacements (element-wise) for `from`.
#'
#' @return A character vector.
#' @export
#'
#' @section TODO:
#' This is a bare bone implementation; dispatch to stringi functions
#' will be implemented.
#'
#' @examples
#' string <- "Here, is a string: this is a test one."
#' from <- c("H.*,", ":", "\\.")
#' to <- c("", "", "")
#' replace_in_string(string, from, to)
#'
#' @importFrom stringi stri_replace_all_regex
replace_in_string <- function(string, from, to) {
  stri_replace_all_regex(
    string,
    pattern = from,
    replacement = to,
    vectorize_all = FALSE
  )
}


#' Standardize the character columns of a `DataFrame` object.
#'
#' Given a `DataFrame`, a set of columns and a list of replacements,
#' will perform a standard pre-processing of strings: a) lowercasing, b)
#' characters replacements, c) white spaces squishing (removes whitespace from
#' start and end of string, also reduces repeated whitespace inside a string).
#'
#' @param df A `DataFrame` object.
#' @param columns A character vector of the columns' names to perform the
#'   operation on.
#' @param replacements The replacements to operate in the string.
#'
#'   A list of element-wise mapping of patterns to be replaced with their
#'   replacements.
#'   A the name of a pre-defined set of replacements, contained in the
#'   replacements_ environmental list object variable.
#'
#' @return A `DataFrame` object
#' @export
#'
#' @examples
#' columns <- c("address", "trading_name")
#' standardize_strings(businesses, columns, replacements='ghbusiness')
#'
#' columns <- c("address", "trading_name")
#' from <- c(',', '\\(.*\\)', '&')
#' to <- c('', '', ' and ')
#' standardize_strings(
#'   businesses,
#'   columns,
#'   replacements=list(from, to)
#'   )
standardize_strings = function(df, columns, replacements = 'ghbusiness') {
  # replacements from glob replacements_ mapping
  if (is.character(replacements)) {
    stopifnot(replacements %in% names(replacements_))

    from <- replacements_[[replacements]][['from']]
    to <- replacements_[[replacements]][['to']]
  }

  # user provided replacements
  if (is.list(replacements)) {
    stopifnot(length(replacements[[1]]) == length(replacements[[2]]))

    from <- replacements[[1]]
    to <- replacements[[2]]
  }

  df %>%
    mutate_at(columns, tolower) %>%
    mutate_at(columns, ~replace_in_string(.x, from, to)) %>%
    mutate_at(columns, str_squish)
}
