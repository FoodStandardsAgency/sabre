#include <Rcpp.h>
#include <regex>
#include <iostream>
#include <sstream>
#include <vector>
#include <string>
#include <cstdio>

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

std::vector<std::string> str_split_cpp(std::string str, std::string token)
{
    std::vector<std::string> res;

    while (str.size())
    {
        int index = str.find(token);

        // captures from begining up to token
        if (index != std::string::npos)
        {
            std::string substring = str.substr(0, index);

            if (substring.size())
                // res.push_back(str.substr(0, index)); // up to token
                res.push_back(substring); // up to token

            str = str.substr(index + token.size()); // token till end of string
        }

        // end of string, when all tokens have been found
        else
        {
            res.push_back(str);
            str = "";
        }
    }
    return res;
}

// [[Rcpp::export]]
CharacterVector parse_nested_records(std::vector<std::string> s,
                                     std::string sep_from,
                                     std::string sep_to)
{
    int n = s.size();

    // std::vector<std::string> res(n);
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
