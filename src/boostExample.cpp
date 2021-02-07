// [[Rcpp::depends(BH)]]

#include <Rcpp.h>
#include <boost/math/common_factor.hpp>

//' @title computeGCD
//' @description
//' Compute GCD
//' @name computeGCD
//' @param a is an integer
//' @param b is an integer
//'
//' @export
// [[Rcpp::export]]
int computeGCD(int a, int b)
{
    return boost::math::gcd(a, b);
}
