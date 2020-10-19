businesses <- structure(
  list(index = 1:8,
       address = c("KINKER HOUSE, GUILD STREET, MIDDLESBROUGH,REDCAR AND CLEVELAND, TS4 6UD",
                   "FACTORY HOUSE 202-205, BOROUHBRIDGE ROAD, MIDDLESBROUGH, MIDDLESBROUGH, TS1 5QW",
                   "Dockers Road, Grangetown, TS3 3UD",
                   "1, ONE STOP SHOPPING PARK, ROMAI ROAD, BIRMINGHAM,  BIRMINGHAM, B2 9DY|UNITS 1 AND 34, ONE STOP RETAIL CENTRE 2, WALLSTREET ROAD, PERRY BARR, BIRMINGHAM, BIRMINGHAM, B2 9DY",
                   "23 Abbess Grove,BIRMINGHAM,  BIRMINGHAM,B25 8YB",
                   "Ninth Street 39 , Glasgow G12 0ZS",
                   "66 Guild St, London, SE16 1BE",
                   "54 Cunnery Rd, London EC2M 1AA"
       ),
       postcode = c("TS4 6UD", "TS1 5QW", "TS3 3UD", "B42 1AB",
                    "B25 ", "G12 0ZS", "SE16 1BE", "EC2M 1AA"),
       trading_name = c("The Missions plc",
                        "The Lockers 2",
                        "Sextans Group UK & Ireland Ltd",
                        "Cosy café @ The horse and hound",
                        "Food Zone t/a ReFood",
                        "Hocus Pocus t/aVan Leer",
                        "Media Luna Bakery Ltd trading as Media Luna",
                        "t/a Pharmacy Doherty")
  ),
  row.names = c(NA, -8L),
  class = c("tbl_df", "tbl", "data.frame")
)

use_data(businesses, overwrite = TRUE)
