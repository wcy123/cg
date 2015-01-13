        .section .text
	.globl cg_create
cg_create:
	/*  ARG1, function entry; */
	/*  ARG2, f arg1 */
	/*  ARG3, f arg2 */
	pushq %rdi        /*  save function entry */
	pushq %rsi        /*  save arg1 */
	pushq %rdx        /*  save arg2     */
	movq  $0x18, %rdi   /*  $18 is sizeof(struct cg_s) */
	callq cg_malloc    /*  allocate this */
	/*  init stack */
	push %rax            /*  save this */
	movq $0x80,  %rdi     /*  alloc stack, MIN_STACK_SIZE = 0x80 */
	call cg_malloc      /*  alloc stack */
	popq %rdi            /*  restore this */
	movq $0x58, 0x0(%rdi)    /*  save this->stack_size */
	movq %rax, 0x8(%rdi)    /*  save this->stack */
	movq $0x0, 0x10(%rdi)    /*  save this->is_done = 0 */        
	movq %rax, %r8
	movq %rdi, %rax 
	/*  restore args */
	popq %rsi /*  arg2 */
	popq %rdi /*  arg1 */
	popq %rdx   /*  function entry */
	/*  save registers */
	movq $cg_fire, 0x00(%r8) /*  the fire, resume return to fire, ready to resume foo. */
	movq %rdi, 0x8(%r8)
	movq %rsi, 0x10(%r8)
	movq %r15, 0x18(%r8)
	movq %r14, 0x20(%r8)
	movq %r13, 0x28(%r8)
	movq %r12, 0x30(%r8)
	movq %rbx, 0x38(%r8)
	movq %rbp, 0x40(%r8)     /*  the fire will pops 8 regs and  */
	movq %rdx, 0x48(%r8)     /*  retq to foo address, intially, function entry point. */
	/*  foo stack space, initally, empty */
	/*  `world` invoke `cg_resume`, and `cg_resume` must push 8 regs */
	/*  i.e. save callee saved registers for `fire`, comply to the calling convention. */
	movq $cg_fire, 0x50(%r8) /*  the fire will return to world */
	retq
/*
 *
 */
        .globl cg_fire
cg_fire:
	    pop %rdi
	    pop %rsi
	    pop %r15
	    pop %r14
	    pop %r13
	    pop %r12
	    pop %rbx
	    pop %rbp
	    retq
/*
  -------------------------------
 */      
	    .globl cg_invoke
cg_invoke:
	push %rbp
	push %rbx
	push %r12
	push %r13
	push %r14
	push %r15
	push %rsi
	push %rdi
        movq %rsi, %r12
	movq (%rdi),%rdx /*  stack size in quadword */
	subq %rdx, %rsp  /*  alloc stack */
	/*  restore stack */
        movq $0x1, 0x10(%rdi) /* this->is_done = 1 */
	movq 0x8(%rdi), %rsi /*  this->stack, read  */
	movq %rsp, %rdi  /*  dst */
	call memcpy
        movq %r12, %rax
	retq /*  return to fire, haha */

/* --------------------------
 * 
 */	

	    .globl cg_return
cg_return:    
	pushq %rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
	pushq %rsi
	pushq %rdi
	pushq $cg_fire
	movq  %rsi, %r12 /*  push return value */
	movq  %rdi, %rdx /*  frame address to %rdx */
	subq  %rsp, %rdx /*  calculate diff */
	addq  $0x10, %rdx /*  include `fire` and return address */
	movq  0x10(%rdi), %rdi /*  skip fire, then the co handler */
        movq  %rsp, %rsi
        call  cg_copy_stack
	addq  %rdx, %rsp /* pop to fire */
	subq  $0x8, %rsp /* pop to fire */
	movq  %r12, %rax /*  pop return value */
	retq
