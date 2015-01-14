# details of implementation

It is only support amd64+Linux.

1. at the beginning of `cg_invoke`

```
.L2:
    push %rbp
    movq %rsp, %rbp
	push %rbx
	push %r12
	push %r13
	push %r14
	push %r15
	push %rsi
	push %rdi
```

the stack is like below

```
+--------------------------+
| rdi                      |
| rsi                      |
| r15                      |
| r14                      |
| r13                      |
| r12                      |
| rbx                      |
| rbp                      |
| return address of `main` | in `cg_invoke`
|--------------------------|
| frame of `main`          | 
| ...                      | in `main`
| ...                      |
```

`rbp`, `rbx`, `r12`, `r13`, `r14`, and `r15` are callee saved
registered. These are the environment must be saved so that `cg_yield`
could rewind the stack, and return directly to `main`.

`rdi` is the `struct cg_t * co`, which is used to save the stack of
the generator.

`rsi` is the return value of `cg_yield`, save it anyway.

2. restore the stack

```
	movq (%rdi),%rdx          /*  stack size in byte */
	subq %rdx, %rsp           /*  alloc stack */
    movq $0x1, 0x10(%rdi)     /* this->is_done = 1 */
	/*  restore stack */
	movq 0x8(%rdi), %rsi      /*  this->stack, read  */
	movq %rsp, %rdi           /*  dst */
	call memcpy
```

after `memcpy`, the stack is as below

```
    +--------------------------+
a ->| rdi                      |
    | rsi                      |
    | r15                      |
    | r14                      |
    | r13                      |
    | r12                      |
    | rbx                      |
    | rbp                      |
    | return address           | in `cg_return`
    |--------------------------|
    | variable size of space   |
    | for the generator        |
b ->| return address           | in `generator`
    |--------------------------| 
    | rdi                      |
    | rsi                      |
    | r15                      |
    | r14                      |
    | r13                      |
    | r12                      |
    | rbx                      |
    | rbp                      |
    | return address of `main` | in `cg_invoke`
    |--------------------------|
    | frame of `main`          |
    | ...                      |

```

`this->stack` store the memory from `b` to `a`, inclusive.




