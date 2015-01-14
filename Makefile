
CFLAGS += -std=c99
CFLAGS += -Wall -Werror
ASFLAGS += -g
all: a.out

a.out: cg_test.o cg_utils.o cg_linux_amd64.o
	gcc -o $@ $+
cg_fib: cg_fib.o cg_utils.o cg_linux_amd64.o
	gcc -o $@ $+

