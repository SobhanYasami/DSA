# Makefile for Binary Search Assembly Implementation
# Builds and links the assembly code with C runtime

# Compiler and linker settings
ASM = nasm
CC = gcc
ASM_FLAGS = -f elf64
CC_FLAGS = -no-pie

# Targets
TARGET = bs
SOURCE = bs.asm
OBJECT = bs.o

# Default target
all: $(TARGET)

# Link object file with C runtime
$(TARGET): $(OBJECT)
	$(CC) $(CC_FLAGS) -o $(TARGET) $(OBJECT)

# Assemble the source code
$(OBJECT): $(SOURCE)
	$(ASM) $(ASM_FLAGS) $(SOURCE)

# Run the program
run: $(TARGET)
	./$(TARGET)

# Clean build files
clean:
	rm -f $(TARGET) $(OBJECT)

# Debug build with symbols
debug: ASM_FLAGS += -g
debug: $(TARGET)

.PHONY: all run clean debug