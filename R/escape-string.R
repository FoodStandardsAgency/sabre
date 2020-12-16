#' Escape characters in string. Make safe for string operations.
#'
#' @param string A character vector.
#'
#' @return A character vector.
#' @export
#'
#' @examples
#' escape_string("(Unit 8) 23 Woodland Road")
escape_string <- function(string) {
  from <-
    c("\\(", "\\)", "\\+", "\\*", "\\[", "\\]", "\\{", "\\}", "\\?")
  to <-
    c(
      "\\\\(",
      "\\\\)",
      "\\\\+",
      "\\\\*",
      "\\\\[",
      "\\\\]",
      "\\\\{",
      "\\\\}",
      "\\\\?"
    )

  replace_in_string(string, from, to)
}
