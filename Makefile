
CFLAGS += -std=c99
CFLAGS += -Wall -Werror
ASFLAGS += -g
all: cg_fib

cg_fib: cg_fib.o cg_utils.o cg_linux_amd64.o
	gcc -o $@ $+
