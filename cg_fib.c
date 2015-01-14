#include <stdio.h>
#include <stdlib.h>
#include "cg.h"
uintptr_t fib(uintptr_t limit)
{
    uintptr_t a=1;
    uintptr_t b=1;
    uintptr_t t=0;
    uintptr_t flag = 0;
    do {
        t = a+b;
        a = b;
        b = t; 
        flag = cg_yield(__builtin_frame_address(0), t);
    }while(flag);
    return t;
}
int main(int argc, char *argv[])
{
    cg_t * co = cg_create((void*)fib,0,0);
    uintptr_t x = 0;
    for(x = cg_invoke(co, x < 100);
        !cg_is_done(co);
        x = cg_invoke(co, x < 100)){
        fprintf(stderr,__FILE__ ":%d:[%s] %ld \n",__LINE__, __FUNCTION__
                ,x);

    }
    return 0;
}

