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
| ...                      |
| rdi                      |
| rsi                      |
| r15                      |
| r14                      |
| r13                      |
| r12                      |
| rbx                      |
| rbp                      |
| return address of `main` |
| frame of `main`          |
| ...                      |
```
