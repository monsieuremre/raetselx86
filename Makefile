# This file is part of RAETSELx86 <https://github.com/monsieuremre/raetselx86>
# RAETSELx86 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
# RAETSELx86 is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>. 

UNAME := $(shell uname)
MAKE = make
CC = gcc
ASM = nasm

# This theoretically makes the program compile on any GNU/Linux and MacOS system, including the new ones with arm processors, but compilation on MacOS was never tested.
ifeq ($(UNAME), Darwin)
ASMFLAGS = -f macho64 -O0
ifeq ($(ARCH), arm64)
X86_ON_ARM=arch -x86_64
endif
else
ASMFLAGS = -f elf64 -O0
endif
CFLAGS = -O0

EXE = enigma
CSRC=$(wildcard *.c) # C sources
ASRC=$(wildcard *.asm) # ASM sources
OBJ=$(CSRC:.c=.o) # Object files of C
OBJ+=$(ASRC:.asm=.o) # Object files of ASM

.PHONY: clean all

$(EXE): $(OBJ) 
	$(X86_ON_ARM) $(CC) $(CFLAGS) -o $(EXE) $(OBJ) 
	
%.o : %.c 
	$(X86_ON_ARM) $(CC) -c $(CFLAGS) -o $@ $< 

%.o : %.asm 
	$(X86_ON_ARM) $(ASM) $(ASMFLAGS) -o $@ $< 

all: $(EXE) $(OBJ)

clean: 
	rm -rf *.o $(EXE)
