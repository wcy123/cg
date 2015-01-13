
CFLAGS += -std=c99
CFLAGS += -Wall -Werror

all: a.out

a.out: cg_test.o cg_utils.o cg_linux_amd64.o
	gcc -o $@ $+
