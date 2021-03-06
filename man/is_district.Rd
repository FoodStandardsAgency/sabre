% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/address.R
\name{is_district}
\alias{is_district}
\title{Is the string the district part of a postcode.}
\usage{
is_district(postcode, ignore_case = FALSE)
}
\arguments{
\item{postcode}{A character string.}

\item{ignore_case}{A boolean.}
}
\value{
A boolean.
}
\description{
Is the string the district part of a postcode.
}
\examples{
is_district("EC2A")
is_district("se16", ignore_case = TRUE)
}
