#include <regex>
#include <iostream>
#include <sstream>
#include <vector>
#include <string>
#include <cstdio>

#include <Rcpp.h>
#include "str_split.h"

using namespace Rcpp;

Rcpp::String unique_and_collapse(std::vector<std::string> v, std::string sep)
{
    std::stringstream ss;
    std::string res;

    std::sort(v.begin(), v.end());
    v.erase(std::unique(v.begin(), v.end()), v.end());

    for (auto it = v.cbegin(); it != v.cend(); ++it)
    {
        ss << *it << sep;
    }

    res = ss.str();

    // remove trailing separator
    if (!res.empty())
    {
        res.erase(res.size() - 1);
    }

    Rcpp::String res_copy;
    res_copy = res;
    res_copy.set_encoding(CE_UTF8);

    return res_copy;
}

std::string str_squish_cpp(const std::string str)
{
    std::string res;

    res = std::regex_replace(str, std::regex("^ +| +$|( ) +"), "$1");

    return res;
}

//' @title parse_nested_records
//' @description
//' Deduplicate and optionally change separators in nested records.
//' @name parse_nested_records
//' @param s a vector of strings
//' @param sep_from string separator in input strings
//' @param sep_to string separator in output strings
//'
//' @export
// [[Rcpp::export]]
CharacterVector parse_nested_records(std::vector<std::string> s,
                                     std::string sep_from,
                                     std::string sep_to)
{
    int n = s.size();

    CharacterVector res(n);
    std::vector<std::string> substrings;

    for (int i = 0; i < n; i++)
    {
        substrings = str_split_cpp(s[i], sep_from);
        int m = substrings.size();

        for (int j = 0; j < m; j++)
        {
            substrings[j] = str_squish_cpp(substrings[j]);
        }

        res[i] = unique_and_collapse(substrings, sep_to);
    }

    return res;
}
