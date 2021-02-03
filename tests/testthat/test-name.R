context("name")

#strip_business_legal_entity_type
test_that("strip entity type from name", {
  expect_equal(
    strip_business_legal_entity_type("Farmer Box Plc."),
    "Farmer Box"
  )
  expect_equal(
    strip_business_legal_entity_type("Farmer Box Limited"),
    "Farmer Box"
  )
  expect_equal(
    strip_business_legal_entity_type("Farmer Box Ltd."),
    "Farmer Box"
  )
  expect_equal(
    strip_business_legal_entity_type("Farmer Box Incorporated"),
    "Farmer Box"
  )
})

test_that("strip honorific title from name", {
  titles <- c(
    "mr and mrs",
    "mr and ms",
    "Ms and ms",
    "mr and miss.",
    "Mr Miss",
    "mr & mrs",
    " miss Mr ",
    "Mr and Mrs and Miss Holmes",
    "Mr Robert and Mrs Anna Wilson and Professor Holmes",
    " and Mr ",
    "Mr Andy",
    "Mr and Holmes, Miss Enola Holmes",
    "Mrs.",
    "Hello World",
    "Mr. Holmes",
    "Miss Holmes Ms",
    "M&S",
    "Hussain",
    "Private Drive Road",
    "Mr Holmes missed his binoculars",
    "Dr. Jekyll and Mr Hyde",
    "DS Wrap",
    "Denis",
    "Drs Associates",
    "D. Smith",
    "d's cafe",
    "Prof Holmes",
    "Prof. Holmes",
    "Professor Holmes",
    "Tharaldr Coffee",
    "Omr",
    "Dismiss",
    "ss Hussain",
    "Robert Downey sr"
  )
  titles_stripped <-
    c(
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "and Holmes",
      "Robert and Anna Wilson and Holmes",
      "and",
      "Andy",
      "Holmes, Enola Holmes",
      "",
      "Hello World",
      "Holmes",
      "Holmes",
      "M&S",
      "Hussain",
      "Private Drive Road",
      "Holmes missed his binoculars",
      "Jekyll and Hyde",
      "DS Wrap",
      "Denis",
      "Drs Associates",
      "D. Smith",
      "d's cafe",
      "Holmes",
      "Holmes",
      "Holmes",
      "Tharaldr Coffee",
      "Omr",
      "Dismiss",
      "ss Hussain",
      "Robert Downey sr"
    )
  expect_equal(
    strip_honorific_title(titles),
    titles_stripped
  )
})
