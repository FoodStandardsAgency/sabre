context("string")

# replace_in_string
test_that("string replacements", {
  string_test <- "This, is a string: this is a test."

  # --- Mix simple regex, characters, punctuation ---
  from <- c("T.*,", ":", "i", "\\.")
  to <- c("", "", "", "")
  expect_equal(
    replace_in_string(string_test, from, to),
    " s a strng ths s a test"
  )

  # --- Remove punctuation and all words with an "i" ---
  from <- c(",", ":", "\\.", "\\b\\w*i\\w*\\b")
  to <- c("", "", "", "")
  expect_equal(
    replace_in_string(string_test, from, to),
    "  a    a test"
  )

  # --- Remove t/a (trading as) and / (two cases with "/")---
  string_ta <- "Farmers Jay t/a Farmers J / this /this this/ t/atila diplomat/a"
  from <- c("t\\/a", "\\/")
  to <- c("", "")
  expect_equal(
    replace_in_string(string_ta, from, to),
    "Farmers Jay  Farmers J  this this this tila diploma"
  )

  # --- Special characters ---
  string_test <- "Cosy café @ The horse and hound's"
  from <- c("@", "'")
  to <- c("", "")
  expect_equal(
    replace_in_string(string_test, from, to),
    "Cosy café  The horse and hounds"
  )

  # --- Special characters and backslash ---
  string_test <- "Cosy café @ The horse \ and \ hound's"
  from <- c("@", "\\\\", "'")
  to <- c("", "", "")
  expect_equal(
    replace_in_string(string_test, from, to),
    "Cosy café  The horse  and  hounds"
  )
})


# standardize_strings
