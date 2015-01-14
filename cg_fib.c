#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "cg.h"
uintptr_t fib(uintptr_t limit, uintptr_t undef)
{
    uintptr_t a=1;
    uintptr_t b=1;
    uintptr_t t= a + b;
    uintptr_t count = 0;
    for(t = a+b; t < limit; t = a+b){
        count = cg_yield(__builtin_frame_address(0), t);
        a = b; b = t;
        fprintf(stderr,__FILE__ ":%d:[%s] %ld => %ld\n", __LINE__, __FUNCTION__
                ,count, t);
    }
    return undef;
}
int main(int argc, char *argv[])
{
    const uintptr_t undef = 1976;
    cg_t co; cg_init(&co,(void*)fib,100,undef);
    uintptr_t x = 0;
    uintptr_t count = 0;
    for(x = cg_invoke(&co, count++);
        x != undef;
        x = cg_invoke(&co, count++)){
        fprintf(stderr,__FILE__ ":%d:[%s] %ld \n",__LINE__, __FUNCTION__,x);

    }
    assert(cg_is_done(&co));
    return 0;
}

