#pragma once
#include <stdint.h>
#include <stdlib.h>
#if (defined(__x86_64__) || defined (__amd64__)) && defined(__linux__)
#define MIN_STACK_SIZE 0x80
#else
#error unsupported architecture
#endif
typedef struct cg_s{
    uintptr_t stack_size;
    uintptr_t * stack;
    uintptr_t is_done;
} cg_t;

void     cg_init(cg_t * cg, void * fun, uintptr_t arg1, uintptr_t arg2);
uintptr_t cg_invoke(cg_t * co, uintptr_t ret);
uintptr_t cg_yield(void * frame,uintptr_t ret);
uintptr_t cg_is_done(cg_t * co);

