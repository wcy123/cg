        .section .text
        .global cg_init
        .type cg_init, @function
cg_init:
	/*  ARG1, function entry; */
	/*  ARG2, f arg1 */
	/*  ARG3, f arg2 */
	pushq %rsi        /*  save function entry */
	pushq %rdx        /*  save arg1 */
	pushq %rcx        /*  save arg2     */
        pushq %rdi        /*  save this */
	/*  init stack */
	movq $0x80,  %rdi     /*  alloc stack, MIN_STACK_SIZE = 0x80 */
	call cg_malloc@PLT        /*  alloc stack */
	popq %r8              /*  restore this */
	movq $0x50, 0x00(%r8)    /*  save this->stack_size  */
	movq %rax , 0x08(%r8)    /*  save this->stack       */
	movq $0x0 , 0x10(%r8)    /*  save this->is_done = 0 */
        movq %rax , %r8
	/*  restore args */
	popq %rsi             /*  arg2 */
	popq %rdi             /*  arg1 */
	popq %rdx             /*  function entry */
	/*  save registers */
	movq %rdi, 0x00(%r8)
	movq %rsi, 0x08(%r8)
	movq %r15, 0x10(%r8)
	movq %r14, 0x18(%r8)
	movq %r13, 0x20(%r8)
	movq %r12, 0x28(%r8)
	movq %rbx, 0x30(%r8)
	movq %rbp, 0x38(%r8)     /*  the fire will pops 8 regs and  */
	movq %rdx, 0x40(%r8)     /*  return address of `generator,initially, function entry point. */
	/*  foo stack space, initally, empty */
	lea (cg_fire)(%rip), %rax
        movq %rax, 0x48(%r8) /*  return address of `cg_invoke`*/
	retq
                                /* .size   cg_init, .-cg_init */
        /*
 *
 */
/*
  -------------------------------
 */      
	.globl cg_invoke
        .type cg_invoke, @function
cg_invoke:
        cmpq $0,0x10(%rdi)    /* if this->is_done */
        je   .L2
        call abort@PLT
.L2:	push %rbp
        movq %rsp, %rbp
	push %rbx
	push %r12
	push %r13
	push %r14
	push %r15
	push %rsi
	push %rdi
        movq %rsi, %r12           /*  save the return value for cg_yield */
	movq (%rdi),%rdx          /*  stack size in byte */
	subq %rdx, %rsp           /*  alloc stack */
        movq $0x1, 0x10(%rdi)     /* this->is_done = 1 */
	/*  restore stack */
	movq 0x8(%rdi), %rsi      /*  this->stack, read  */
	movq %rsp, %rdi           /*  dst */
	call memcpy@PLT
        movq %r12, %rax           /* restore the return value for cg_yield */
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
        .size   cg_invoke, .-cg_invoke
/* --------------------------
 * 
 */	

	.globl cg_yield
        .type cg_yield, @function
cg_yield:    
        /* begin save callee saved registers, rsi and rdi*/
	pushq %rbp
	pushq %rbx
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
	pushq %rsi
	pushq %rdi
        /* end save callee saved registers, rsi and rdi*/        
	movq  %rsi, %r12  /*  save yield value by generator */
	movq  %rdi, %rdx  /*  frame address to %rdx */
	subq  %rsp, %rdx  /*  calculate diff */
        addq  $0x10, %rdx /* include cg_fire */
	movq  0x10(%rdi), %rdi /*  skip cg_fire, cg handler */
        movq  %rdx, %r13       /* save it */
        movq  %rsp, %rsi
        call  cg_copy_stack@PLT
	addq  %r13, %rsp /* rewind the stack of the generator */
	movq  %r12, %rax /*  restore return value of yield, passed by cg_invoke */
cg_fire2: /* this must be inline with cg_fire */
        pop %rdi
	pop %rsi
	pop %r15
	pop %r14
	pop %r13
	pop %r12
	pop %rbx
	pop %rbp
	retq
        .size cg_yield, .-cg_yield
