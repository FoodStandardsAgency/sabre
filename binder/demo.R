library(sabre)
library(Rcpp)

sourceCpp("./dev/gapfill_postcodes.cpp")
sourceCpp("./dev/parse_nested_records.cpp")


# ------------------------------------------------------------------------------
# --- ABOUT ---
# ------------------------------------------------------------------------------
# 1. Library as a set of wrappers around:
#  - stringr
#  - stringi
# 2. Regex logic, pattern detection, tokenization and fuzzy matching in development
# 3. Uses (as much as possible) the tidyr style
# 5. purrr functional style of programming prefered when possible
# 6. Some enhancement in RCpp for speed and large datasets


# ------------------------------------------------------------------------------
# --- BASIC OPERATIONS ---
# ------------------------------------------------------------------------------
# Strip business legal entity type from strings
strip_business_legal_entity_type("Farmer Box Plc.")
strip_business_legal_entity_type("Farmer Box Incorporated")


# Strip honorific titles from a name
# 1. handles most general cases (Mr, Mrs, Dr., ...)
# 2. avoid catching similar terms
strip_honorific_title("Dr. Jekyll and Mr Hyde")
strip_honorific_title("Mr Holmes missed his binoculars")


# Given a string with multiple postcodes and addresses,
# extract postcodes and addresses
fox_string <-
  "The quick brown fox's postcode is N17 0RN and his house number is 6. The family den extends under number 22A-23b Fox street, which marks the West end of E3. If you cannot reach him, try his relatives at 7Caledonian Road, or 19C, 20A&20B EC30RN but do not forget the separating white space after the district's code E3."

find_postcodes_in_string(fox_string)
find_buildings_numbers(fox_string)


# Reformat postcodes
format_postcode("EC3R0RN")
format_postcode("N17RN  ")


# Given an unclean dataset of business records:
# - address
# - postcode
# - trading name
businesses

# Standardize strings in a dataset
standardize_replacements <- list(
  from = c(",", "&"),
  to = c(" ", " and ")
)
standardize_strings(businesses, colnames(businesses), replacements = standardize_replacements)


# ------------------------------------------------------------------------------
# --- DATA CLEANING ---
# ------------------------------------------------------------------------------
# Melt rows (= separate nested records) over several lines
# by choosing separators
businesses[4:8, c("postcode", "trading_name")]

melt_rows(
  businesses[4:8, 3:4],
  "trading_name",
  dividers = c("\\|", " trading as ", "(?<!^)t/a(?<!$)", "@")
)

# Chain operations
melt_rows(
  businesses[4:8, 3:4],
  "trading_name",
  dividers = c("\\|", " trading as ", "(?<!^)t/a(?<!$)", "@")
) %>%
  dplyr::mutate_at(., "trading_name", ~ replace_in_string(., "t/a", "")) %>%
  dplyr::mutate_at(., "trading_name", strip_business_legal_entity_type) %>%
  dplyr::mutate_at(., "trading_name", stringr::str_squish)


# Remove redundant information between columns
# multiple common operations in development (on token and on fuzzy match)

# Exact match only, case sensitive
col_diff(businesses[1:8, 2:3],
  address,
  postcode,
  how = c("exact")
)

# Will perform diff after lowercase and squish
col_diff(businesses[1:8, 2:3],
  address,
  postcode,
  how = c("lowercase", "squish")
)


# Gapfilling of postcodes using postcode and address columns
postcode <-
  c(
    "EC2A 3JX",
    "",
    "not a postcode",
    "wc2h 9ja"
  )

address <-
  c(
    "EC3A 3JX, 29 Churchyard Road EC2A 3JX",
    "30 Church Street N16 3PT",
    "29 Churchyard Road SE1 3PT",
    "Prof Holmes c/o Enola 25 turmoil road"
  )

gapfill_postcode_cpp(postcode, address)


# Deduplicate, squish and change sep for nested records
nested_record <- "111|111|222|222|333|333"
parse_nested_records(nested_record, "|", ",")


# ------------------------------------------------------------------------------
# --- EXAMPLE OF A CLEANING WORKFLOW ---
# ------------------------------------------------------------------------------
standardize_replacements <- list(
  from = c(",", "&"),
  to = c(" ", " and ")
)

businesses %>%
  standardize_strings(
    colnames(businesses), replacements = standardize_replacements
  ) %>%
  mutate(
    postcode = gapfill_postcode_cpp(postcode, address)
  ) %>%
  mutate_at(
    vars(postcode, address),
    ~ tolower(.x)
  ) %>%
  melt_rows(
    "trading_name",
    dividers = c("\\|", " trading as ", "(?<!^)t/a(?<!$)", "@")
  ) %>%
  mutate_at("trading_name", ~ replace_in_string(., "t/a", "")) %>%
  mutate_at("trading_name", strip_business_legal_entity_type) %>%
  mutate_at("trading_name", stringr::str_squish) %>%
  melt_rows(
    "address",
    dividers = c("\\|")
  ) %>%
  col_diff(
    address, postcode, how = c("lowercase", "squish")
  )

# ... ready for fuzzy matching
