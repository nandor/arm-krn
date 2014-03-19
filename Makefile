AS=arm-none-eabi-as
CC=arm-none-eabi-gcc
LD=arm-none-eabi-ld
OC=arm-none-eabi-objcopy

ASFLAGS=-march=armv5te
CFLAGS= -mcpu=arm926ej-s -c -nostdlib -nostartfiles -ffreestanding
LDFLAGS=

OBJECTS=kernel.o\
				stdio.o

all: kernel.bin

kernel.bin: kernel.elf
	$(OC) -O binary kernel.elf kernel.bin

kernel.elf: $(OBJECTS) kernel.ld
	$(LD) -T kernel.ld $(LDFLAGS) $(OBJECTS) -o kernel.elf

%.o: %.s
	$(AS) $(ASFLAGS) $< -o $@

%.o: %.c
	$(CC) $(CFLAGS) $< -o $@

clean:
	rm -rf kernel.bin
	rm -rf kernel.elf
	rm -rf *.o

debug:
	qemu-system-arm -M versatilepb -m 128M -nographic -s -S -kernel kernel.bin

run:
	qemu-system-arm -M versatilepb -m 128M -nographic -kernel kernel.bin