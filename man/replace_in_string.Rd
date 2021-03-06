% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/string.R
\name{replace_in_string}
\alias{replace_in_string}
\title{Replace (substitutes) patterns in a string.}
\usage{
replace_in_string(string, from, to, squish_ws = FALSE)
}
\arguments{
\item{string}{A character vector.}

\item{from}{A string vector containing the patterns (regex, as string) to be
matched.}

\item{to}{A string vector of the replacements (element-wise) for \code{from}.}

\item{squish_ws}{A boolean; determines if trailing white spaces and repeated
whitespace inside a string (generated by the replacement), are trimmed or
not.}
}
\value{
A character vector.
}
\description{
Wrapper of the stringi \code{stri_replace_} family of functions.
}
\details{
Given two vectors mapping the patterns to be replaced with their
replacements, return a new string.
}
\section{TODO}{

This is a bare bone implementation; dispatch to stringi functions
will be implemented.
}

\examples{
string <- "Here, is a string: this is a test one."
from <- c("H.*,", ":", "\\\\.")
to <- c("", "", "")
replace_in_string(string, from, to)

}
