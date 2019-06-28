
#include <iostream>

int add(const int &a,const int &b)
{
    return a+b;
}

int main(int argc,char** argv)
{
    printf("-------vscode_dbg_and _makefile-------\n");

    int c = 0;
    c = add(1,2);

    return 0;
}
