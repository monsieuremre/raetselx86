## Preview

![preview]()

## About The Project

World War II was one of the greatest, if not the greatest tragedy of all time. One of the famous stories about this period is how Alan Turing and his team cracked the Enigma Code and aided tremendously in the defeat of exis powers. RAETSELx86 is a project that implements the functionality of the historical Enigma Machine used by Germany in World War II for confidential and secret communication.  This project aims to achieve this using x86 Assembly in an effort to make it easier to educate people on how the historical algorithm worked, what its weaknesses were, and thus provide a way to gain a deep understanding of low level programming by implementing such complicated tasks in assembly. This includes calling assembly from C, calling library functions from assembly, linking them together, adjusting the stack frame in each step and respecting conventional use of registers. We read and write not only from registers, but also from memory, including the ones we allocated within assembly. The name RAETSELx86 comes from the fact that Enigma comes originally from Greek and has the meaning Riddle/Mystery. Raetsel means exactly this in German. And x86 is the architecture this project was implemented for.

## Prerequisites

You have to be running a Unix-Like system, namely either any Linux distribution or MacOS. Windows is not supported at this point. But you can easily use the WSL (Windows Susbsytem for Linux) for this purpose.

You need to have the Netwide Assembler, the GNU Compiler Collection and GNU Make readily installed on your system. If you are on linux, chances are this already came bundled with your distibution. If not, they are probably included in your distributions package manager, in on of the default repositories.

To the best of my knowledge, those on MacOS are also covered. But if not highly recommend you install these using the [Homebrew](https://brew.sh) package manager.

You can also refer to the official websites of [NASM](https://nasm.us), [GCC](https://gcc.gnu.org) and [GNU Make](https://www.gnu.org/software/make/) for installation.

## Compilation
You first have to ideally compile the program, using the following command
```
make
```
Details to what operating system is used makes no difference as this is taken care of in the `Makefile` for your convenience.

## Getting Started

The program has a command line interface for input and output. User needs to give the starting positions of the three rotating rotors. This is like the encryption password. If we use the same password on the encrypted message, we will get the original message in plain text. The program works like the historical machine, so if you know how it worked you would have a better time understanding the code.

Make sure the configuration file is present in the directory. This has the rotor configurations. You can rearrange or change the rotor configurations if you choose to. This was done with the historical machine to create more obfuscation.

The file content line by line should be like this:

| Line | Content |
| --- | --- |
| 1 | Reflector |
| 2 | Left Rotor |
| 3 | Middle Rotor |
| 4 | Right Rotor |
| 5 | Plugboard |

Make sure Reflector and Plugboard are self mapping. Meaning, in a valid configuration, a pair of characters have to map to each other. If C is in the first index, this means A is mapped to C. For it to be self mapping, C has to map to A. That is, in C's index, which is the 3rd, there should be A. So the following example would be a valid configuration for example
`CBADEFGHIJKLMNOPQRSTUVWXYZ`
This requirement only applies to the reflector and to the plugboard. Rotating rotors can have any kind of order, as long as each character is present once.

## Usage
You can run the program by simply running the binary you have successfully compiled.
```
./enigma
```
After this, follow the user prompts.

## Contributing

The fact that anybody can contribute is what makes Free and Open Source Software to learn and create.
If you have any suggestion regarding the project, do not hesitate fork the repo and create a pull request.

## License

RAETSELx86 is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. 

See `LICENSE` for more details.

## Contact

Project Link: []()
