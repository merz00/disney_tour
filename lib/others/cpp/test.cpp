#include <iostream>
#include <fstream>
#include <cassert>
#include <sstream>
#include <cstdio>
#include <chrono>
#include <vector>
#include <algorithm>
#include <numeric>
#include <set>
#include <map>
#include <stdlib.h>
#include <mach-o/dyld.h>
#include <libgen.h>
#include "picojson.h"

using namespace std;
using namespace std::chrono;

int main()
{
    uint32_t bufsize = 1024;
    static char exepath[1024] = {};
    int result = _NSGetExecutablePath(exepath, &bufsize);
    if(result == 0){
        string current_directory = string(exepath);
        cout << current_directory << "\n";
    }else{
        cout << "ERROR\n";
    }
}
