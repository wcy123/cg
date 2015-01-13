#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "cg.h"
#ifndef GC_MALLOC
#define GC_MALLOC malloc
#endif
#ifndef GC_FREE
#define GC_FREE free
#endif
#ifndef GC_REALLOC
#define GC_REALLOC realloc
#endif


void * cg_malloc(size_t s)
{
    return GC_MALLOC(s);
}
void cg_copy_stack(cg_t * co, char * frame, size_t sz)
{
    if(sz <= MIN_STACK_SIZE){
    }else if(sz <= co->stack_size){
    }else {
        // sz > co->stack_size && sz > MIN_STACK_SIZE
        co->stack = GC_REALLOC(co->stack,sz);
        assert(co->stack);
    }
    co->stack_size = sz;
    co->is_done = 0;
    memcpy(co->stack,frame,sz);
}
uintptr_t cg_is_done(cg_t * co)
{
    return co->is_done;
}
