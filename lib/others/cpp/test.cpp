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
#include <unistd.h>
#include "picojson.h"

using namespace std;
using namespace std::chrono;

int main()
{
    static char buf[1024] = {};
    readlink("/proc/self/exe",buf,sizeof(buf)-1);
    string current_directory = string(buf);
    cout << current_directory << "\n";
}
