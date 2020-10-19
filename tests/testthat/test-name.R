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
