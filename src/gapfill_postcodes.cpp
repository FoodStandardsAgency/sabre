#include <algorithm>
#include <regex>
#include <vector>
#include <string>

#include <Rcpp.h>
#include "str_split.h"

using namespace Rcpp;

// [[Rcpp::export]]
Rcpp::String to_upper(std::string str)
{
    // str = std::transform(str.begin(), str.end(), str.begin(), ::toupper);

    for (auto &c : str)
        c = toupper(c);

    Rcpp::String str_utf8;
    str_utf8 = str;
    str_utf8.set_encoding(CE_UTF8);

    return str_utf8;
}

std::regex re_postcode("(\\b[A-Z]{1,2}\\d[A-Z\\d]?|\\w{0}[A-Z]{1,2}\\d[A-Z\\d]?) ?\\d[A-Z]{2}");

// [[Rcpp::export]]
std::string find_postcodes_in_string_cpp(const std::string s)
{
    std::sregex_iterator iter(s.begin(), s.end(), re_postcode);
    std::sregex_iterator end;

    std::stringstream ss;
    std::string res;

    while (iter != end)
    {
        ss << (*iter)[0] << "|";
        ++iter;
    }

    res = ss.str();

    // remove trailing "|"
    if (!res.empty())
    {
        res.erase(res.size() - 1);
    }

    return res;
}

std::regex re_district("^[A-PR-UWYZ]([0-9]{1,2}|([A-HK-Y][0-9]([0-9ABEHMNPRV-Y])?)|[0-9][A-HJKPS-UW])$");

// [[Rcpp::export]]
bool is_district_cpp(std::string s)
{
    s = to_upper(s);

    std::sregex_iterator iter(s.begin(), s.end(), re_district);
    std::sregex_iterator end;

    std::stringstream ss;
    std::string res;

    while (iter != end)
    {
        ss << (*iter)[0] << "|";
        ++iter;
    }

    res = ss.str();

    return !res.empty();
}

std::regex re_sector("^[A-PR-UWYZ]([0-9]{1,2}|([A-HK-Y][0-9]([0-9ABEHMNPRV-Y])?)|[0-9][A-HJKPS-UW]) ?[0-9]$");

// [[Rcpp::export]]
bool is_sector_cpp(std::string s)
{
    s = to_upper(s);

    std::sregex_iterator iter(s.begin(), s.end(), re_sector);
    std::sregex_iterator end;

    std::stringstream ss;
    std::string res;

    while (iter != end)
    {
        ss << (*iter)[0] << "|";
        ++iter;
    }

    res = ss.str();

    return !res.empty();
}

std::regex re_postcode_complete("(GIR ?0AA|[A-PR-UWYZ]([0-9]{1,2}|([A-HK-Y][0-9]([0-9ABEHMNPRV-Y])?)|[0-9][A-HJKPS-UW]) ?[0-9][ABD-HJLNP-UW-Z]{2})");

// [[Rcpp::export]]
bool is_postcode_complete_cpp(std::string s)
{
    s = to_upper(s);

    std::sregex_iterator iter(s.begin(), s.end(), re_postcode_complete);
    std::sregex_iterator end;

    std::stringstream ss;
    std::string res;

    while (iter != end)
    {
        ss << (*iter)[0] << "|";
        ++iter;
    }

    res = ss.str();

    return !res.empty();
}

// [[Rcpp::export]]
Rcpp::String last_cpp(std::vector<std::string> v)
{
    if (!v.empty())
    {
        return v.back();
    }
    return "";
}

//' @title gapfill_postcodes
//' @description
//' Find postcodes in address vector when missing or incomplete in postcode vector.
//' @name gapfill_postcodes
//' @param postcode a vector of strings (same size as address)
//' @param address a vector of strings (same size as postcode)
//'
//' @export
// [[Rcpp::export]]
std::vector<std::string> gapfill_postcodes(std::vector<std::string> postcode,
                                           std::vector<std::string> address)
{
    int n = postcode.size();

    std::vector<std::string> res(n);

    for (int i = 0; i < n; i++)
    {
        std::string postcode_;
        std::string postcode_address;

        if (is_postcode_complete_cpp(postcode[i]))
        {
            // Rcout << "postcode " << i << " is complete \n";

            postcode_ = to_upper(postcode[i]);

            postcode_address =
                last_cpp(
                    str_split_cpp(
                        find_postcodes_in_string_cpp(
                            to_upper(address[i])),
                        "|"));
            // Rcout << "postcode_address " << postcode_address << "\n";

            if ((!postcode_address.empty()) && (postcode_ == postcode_address))
            {
                // Rcout << "postcode_address == postcode \n";
                res[i] = postcode_;
            }

            else if (postcode_address.empty())
            {
                res[i] = postcode_;
            }

            else
            {
                // Rcout << "postcode_address empty or not equal \n";
                res[i] = postcode_address;
            }
        }

        else if ((!is_district_cpp(postcode[i])) && (!is_sector_cpp(postcode[i])))
        {
            postcode_address =
                last_cpp(
                    str_split_cpp(
                        find_postcodes_in_string_cpp(
                            to_upper(address[i])),
                        "|"));

            if (!postcode_address.empty())
            {
                // Rcout << "postcode_address " << i << " is NOT empty ifelse 1 \n";
                res[i] = postcode_address;
            }

            else
            {
                // Rcout << "postcode_address " << i << " IS empty ifelse 1\n";
                res[i] = NumericVector::get_na();
                // res[i] = "NA";
            }
        }

        else if ((is_district_cpp(postcode[i])) || (is_sector_cpp(postcode[i])))
        {
            postcode_address =
                last_cpp(
                    str_split_cpp(
                        find_postcodes_in_string_cpp(
                            to_upper(address[i])),
                        "|"));

            if (!postcode_address.empty())
            {
                // Rcout << "postcode_address " << i << " is NOT empty ifelse 2 \n";
                res[i] = postcode_address;
            }

            else
            {
                // Rcout << "postcode_address " << i << " IS empty ifelse2 \n";
                res[i] = postcode[i]; // could be postcode_ or to_upper(postcode[i])
            }
        }

        // FIXME the last else is not necessary as all other cases are covered
        else
        {
            res[i] = NumericVector::get_na();
            // res[i] = "NA";
        }
    }
    return res;
}
