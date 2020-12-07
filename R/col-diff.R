#' Strip column from strings contained in another column.
#'
#' @param df A data frame object or something coercible to one.
#' @param left Column object to transform, following tidyverse conventions.
#'   Column to remove from, (left - right).
#' @param right Column object to transform, following tidyverse conventions.
#'   Content to remove (left - right).
#' @param how exact, lowercase, squish, token, levenshtein. Can be a combination
#'   such as c('lowercase', 'squish').
#'
#' @return A data frame object.
#' @export
#'
#' @examples
#' col_diff(businesses[1:8, 2:3],
#'          address,
#'          postcode,
#'          how = c('lowercase', 'squish'))
#'
#' @importFrom dplyr enquo mutate across select
#' @importFrom stringr str_replace str_squish
#' @importFrom rlang :=
col_diff <- function(df, left, right, how = "exact") {
  left <- enquo(left)
  right <- enquo(right)



  if (all(how == "exact")) {
    df %>%
      # make special characters safe
      mutate(right_temp := escape_string(!!right)) %>%
      mutate(!!left := str_replace(!!left, right_temp, "")) %>%
      mutate(!!left := str_squish(!!left)) %>%
      select(., -right_temp)
  } else if (all(how == "lowercase")) {
    df %>%
      mutate(right_temp := escape_string(!!right)) %>%
      mutate(across(c(!!left, !!right), ~ tolower(.))) %>%
      mutate(!!left := str_replace(!!left, !!right, "")) %>%
      mutate(!!left := str_squish(!!left)) %>%
      select(., -right_temp)
  } else if (all(how == "squish")) {
    df %>%
      mutate(right_temp := escape_string(!!right)) %>%
      mutate(across(c(!!left, !!right), ~ str_squish(.))) %>%
      mutate(!!left := str_replace(!!left, !!right, "")) %>%
      mutate(!!left := str_squish(!!left)) %>%
      select(., -right_temp)
  } else if (all(how == c("lowercase", "squish"))) {
    df %>%
      mutate(right_temp := escape_string(!!right)) %>%
      mutate(across(c(!!left, !!right), ~ tolower(.))) %>%
      mutate(across(c(!!left, !!right), ~ str_squish(.))) %>%
      mutate(!!left := str_replace(!!left, !!right, "")) %>%
      mutate(!!left := str_squish(!!left)) %>%
      select(., -right_temp)
  }
}
