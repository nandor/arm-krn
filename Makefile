AS=arm-none-eabi-as
CC=arm-none-eabi-gcc
LD=arm-none-eabi-ld
OC=arm-none-eabi-objcopy

ASFLAGS=-march=armv6zk\
				-mfpu=neon\
				-g\

CFLAGS=-march=armv6zk\
			 -mtune=arm1176jzf-s\
			 -Ofast\
			 -mfpu=vfp\
			 -mfloat-abi=hard\
			 -nostartfiles\
			 -g
LDFLAGS=

OBJECTS=kernel.o\
				sys/io.o\
				sys/syscall.o\
				sys/thread.o\
				lib/math.o\
				lib/rasterizer.o\
				lib/test.o

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
	rm -rf -R *.o

debug:
	qemu-system-arm -M versatilepb -m 128M -nographic -s -S -kernel kernel.bin

run:
	qemu-system-arm -M versatilepb -m 128M -nographic -kernel kernel.bin
