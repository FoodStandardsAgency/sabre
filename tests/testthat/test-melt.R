context("melt")

melt_rows
test_that("business names separators", {
  businesses_subset_melt <-
    structure(
      list(
        postcode = c(
          "B42 1AB",
          "B42 1AB",
          "B25 ",
          "B25 ",
          "G12 0ZS",
          "G12 0ZS",
          "SE16 1BE",
          "SE16 1BE",
          "EC2M 1AA",
          "EC2M 1AA"
        ),
        trading_name = c(
          "Cosy café",
          "The horse and hound",
          "Food Zone",
          "ReFood",
          "Hocus Pocus",
          "Van Leer",
          "Media Luna Bakery Ltd",
          "Media Luna",
          "",
          "Pharmacy Doherty"
        )
      ),
      row.names = c(NA,-10L),
      class = c("tbl_df", "tbl", "data.frame")
    )

  expect_equal(
    melt_rows(
      businesses[4:8, 3:4],
      "trading_name",
      dividers = c("\\|", " trading as ", "t/a", "\\/", "@")
    ),
    businesses_subset_melt
  )
})
