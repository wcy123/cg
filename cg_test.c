#include <stdio.h>
#include <stdlib.h>
#include "cg.h"


int foo(int a, int b)
{
    for(int i = 0x1976; i < 0x1976 + a; i++){
        fprintf(stderr,__FILE__ ":%d:[%s] i=%d\n", __LINE__, __FUNCTION__
                ,i);
        int x = cg_return(__builtin_frame_address(0), i);
        fprintf(stderr,__FILE__ ":%d:[%s] x=%d\n", __LINE__, __FUNCTION__
                ,x);

    }
    fprintf(stderr,__FILE__ ":%d:[%s] start to return.\n", __LINE__, __FUNCTION__
            );
    return 100;
}
int main(int argc, char *argv[])
{
    cg_t * co = cg_create((void*)foo, 3,2);
    uintptr_t x = 0;
    uintptr_t i = 0;
    while(!cg_is_done(co)){
        x = cg_invoke(co, x+1);
        fprintf(stderr,__FILE__ ":%d:[%s] i = %ld %ld\n", __LINE__, __FUNCTION__
                ,i++,x);
    }
    fprintf(stderr,__FILE__ ":%d:[%s] finally x = %ld\n", __LINE__, __FUNCTION__
            ,x);

    return 0;
}

