
CFLAGS += -std=c99
CFLAGS += -Wall -Werror
ASFLAGS += -g
all: cg_fib

libcg.so:
	gcc -fPIC -O3 -ggdb -c -o cg_utils.o cg_utils.c 
	cc -g   -c -o cg_linux_amd64.o cg_linux_amd64.S 
	gcc -shared -o $@ cg_linux_amd64.o cg_utils.o
# cg_fib: cg_fib.o cg_utils.o cg_linux_amd64.o
# 	gcc -o $@ $+

cg_fib: cg_fib.c 
	gcc -ggdb -O0 -o $@ $< -L. -lcg
cg_fib: libcg.so

clean:
	rm cg_fib *.o lib*.so
