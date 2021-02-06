#include <string>
#include <vector>

std::vector<std::string> str_split_cpp(std::string str, std::string token)
{
    std::vector<std::string> res;

    while (str.size())
    {
        // int index = str.find(token);
        std::size_t index = str.find(token); // size_t is an unsigned integral type

        // captures from begining up to token
        if (index != std::string::npos)
        {
            std::string substring = str.substr(0, index);

            if (substring.size())
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