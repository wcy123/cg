# cg
A generator library in C

[Wikipedia][] explains the concept of `generator`. The main use cases are

1. Seperate `producer` and `consumer`
2. Avoid `callback` functions.

[Wikipedia]: http://en.wikipedia.org/wiki/Generator_%28computer_programming%29#C.2B.2B


```c
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
    cg_t * co = cg_create((void*)fib,100,undef);
    uintptr_t x = 0;
    uintptr_t count = 0;
    for(x = cg_invoke(co, count++);
        x != undef;
        x = cg_invoke(co, count++)){
        fprintf(stderr,__FILE__ ":%d:[%s] %ld \n",__LINE__, __FUNCTION__,x);

    }
    assert(cg_is_done(co));
    return 0;
}
```

1. `cg_create` at line 22, create a new generator.
   1. function `cg_fib` is not started.
   2. `cg_lib` will start with two arguments, `limit` and `undef`.
   3. `limit` and `undef` could be any user defined value.
2. `cg_invoke` at line 25 and 27, starts the generator.
   1. the first argument `co` is the generator.
   2. the second argument `count` is the return value of `cg_yield`,
   initially, it doesn't make sense.
   3. At first time, `fib` starts from the beginning, i.e. line 7.
3. `cg_yield` at line 12, `cg_fib` suspended and control return to `main`
   1. the first argument must be `__builtin_frame_address(0)`
   2. the second argument is the `yield` value, `t`.
   3. `cg_invoke` returns the yield value `t`.
   4. the stack and enviroment of `cg_fib` is saved and could be restarted later.
4. return of `cg_lib` at line 17. 
   1. the return value of `cg_lib` is also the return value of `cg_invoke`.
   2. after that, `cg_is_done(co)` will return `1`, otherwise, `0`.


see [master/implementation.md]() for the detail document of the implemention.



