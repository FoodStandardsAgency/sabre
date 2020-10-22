context("address")

# find_postcodes_in_string
# find_postcodes
test_that("find postcodes", {
  fox_string <-
    "The quick brown fox's postcode is N17 0RN and his house number is 6. The family den extends under number 22A-23b Fox street, which marks the West end of E3. If you cannot reach him, try his relatives at 7Caledonian Road, or 19C, 20A&20B EC30RN but do not forget the separating white space after the district's code E3."
  postcodes_in_businesses_df <- list(
    index = character(0),
    address = c(
      "TS4 6UD",
      "TS1 5QW",
      "TS3 3UD",
      "B2 9DY",
      "B2 9DY",
      "B25 8YB",
      "G12 0ZS",
      "SE16 1BE",
      "EC2M 1AA"
    ),
    postcode = c(
      "TS4 6UD",
      "TS1 5QW",
      "TS3 3UD",
      "B42 1AB",
      "G12 0ZS",
      "SE16 1BE",
      "EC2M 1AA"
    ),
    trading_name = character(0)
  )

  expect_equal(
    find_postcodes_in_string("A postcodeNW2 7RN with missing ws"),
    "NW2 7RN"
    )
  expect_equal(
    find_postcodes_in_string("A postcode NW2 7RNwith missing ws"),
    "NW2 7RN"
    )
  expect_equal(
    find_postcodes_in_string("A postcode NW2  7RN with extra ws"),
    character(0)
    )
  expect_equal(
    find_postcodes_in_string("A postcode2 7RN with typo"),
    character(0)
    )
  expect_equal(find_postcodes_in_string(fox_string), c("N17 0RN", "EC30RN"))
  expect_equal(find_postcodes_in_string(businesses[['address']][1]), "TS4 6UD")
  expect_equal(
    find_postcodes_in_string(businesses[['address']]),
    c(
      "TS4 6UD",
      "TS1 5QW",
      "TS3 3UD",
      "B2 9DY",
      "B2 9DY",
      "B25 8YB",
      "G12 0ZS",
      "SE16 1BE",
      "EC2M 1AA"
    )
  )
  expect_equal(
    find_postcodes_in_string(businesses),
    c(
      "TS4 6UD",
      "TS1 5QW",
      "TS3 3UD",
      "B2 9DY",
      "B2 9DY",
      "B25 8YB",
      "G12 0ZS",
      "SE16 1BE",
      "EC2M 1AA",
      "TS4 6UD",
      "TS1 5QW",
      "TS3 3UD",
      "B42 1AB",
      "G12 0ZS",
      "SE16 1BE",
      "EC2M 1AA"
    )
  )
  expect_equal(find_postcodes(businesses), postcodes_in_businesses_df)
})

# find_buildings_numbers_in_string
# find_buildings_numbers
test_that("find buildings numbers", {
  fox_string <-
    "The quick brown fox's postcode is N17 0RN and his house number is 6. The family den extends under number 22A-23b Fox street, which marks the West end of E3. If you cannot reach him, try his relatives at 7Caledonian Road, or 19C, 20A&20B EC30RN but do not forget the separating white space after the district's code E3."
  buildings_numbers_in_businesses_df <-
    list(
      index = "1|2|3|4|5|6|7|8",
      address = "202|205|1|1|34|2|23|39|66|54",
      postcode = "",
      trading_name = "2"
    )

  expect_equal(find_buildings_numbers_in_string(fox_string),
               "6|22A|23b|7|19C|20A|20B")
  expect_equal(find_buildings_numbers_in_string("123A-124B High Street"),
               "123A|124B")
  expect_equal(find_buildings_numbers_in_string("52High Street"), "52")
  expect_equal(find_buildings_numbers_in_string("N1 2RN"), "")

  # expect_equal(find_buildings_numbers(businesses),
  #              buildings_numbers_in_businesses_df)
})

# strip_buildings_numbers_in_string
# strip_buildings_numbers
test_that("strip buildings numbers", {
  string <- "The quick brown fox's postcode is N17 0RN and his house number is 6. The family den extends under number 22A-23b Fox street, which marks the West end of E3. If you cannot reach him, try his relatives at 7Caledonian Road, or 19C, 20A&20B EC30RN but do not forget the separating white space after the district's code E3."
  string_no_building_numbers <- "The quick brown fox's postcode is N17 0RN and his house number is . The family den extends under number - Fox street, which marks the West end of E3. If you cannot reach him, try his relatives at Caledonian Road, or , & EC30RN but do not forget the separating white space after the district's code E3."
  expect_equal(
    strip_buildings_numbers_in_string(string),
    string_no_building_numbers
    )
  expect_equal(
    strip_buildings_numbers_in_string("42High Street"),
    "High Street"
    )
  expect_equal(
    strip_buildings_numbers_in_string("7Caledonian Road"),
    "Caledonian Road"
    )
})

test_that("format postcodes", {
  expect_equal(format_postcode("EC3R0RN"), "EC3R 0RN")
  expect_equal(format_postcode("  EC28EE "), "EC2 8EE")
  expect_equal(format_postcode("N17RN  "), "N1 7RN")
})

test_that("is district", {
  expect_equal(is_district("EC2A"), TRUE)
  expect_equal(is_district("EC2A 3JX"), FALSE)
  expect_equal(is_district("se16", ignore_case = TRUE), TRUE)
  expect_equal(is_district("se16 7dx", ignore_case = TRUE), FALSE)
})

test_that("is postcode complete", {
  expect_equal(is_postcode_complete("EC2A"), FALSE)
  expect_equal(is_postcode_complete("EC2A 3JX"), TRUE)
  expect_equal(is_postcode_complete("se16", ignore_case = TRUE), FALSE)
  expect_equal(is_postcode_complete("se16 7dx", ignore_case = TRUE), TRUE)
})

test_that("is postcode partial", {
  expect_equal(is_postcode_partial("EC2A"), TRUE)
  expect_equal(is_postcode_partial("EC2A 3JX"), FALSE)
  expect_equal(is_postcode_partial("se16", ignore_case = TRUE), TRUE)
  expect_equal(is_postcode_partial("se16 7dx", ignore_case = TRUE), FALSE)
})



# find_buildings_numbers_in_string(businesses[['address']])

