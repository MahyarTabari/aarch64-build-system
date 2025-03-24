
# Makefile for AArch64 Cross-Compilation and Debugging

This Makefile is designed to simplify the process of cross-compiling C++ and assembly files for the AArch64 architecture, assembling, linking, and running the resulting binary using an emulator. It also supports debugging the binary using GDB.

## Directory Structure

- **src/cpp-files**: Directory for your C++ source files.
- **src/asm-files**: Directory for your assembly files.
- **obj**: Directory for object files.
- **bin**: Directory for the final compiled binary.

## Requirements

- **aarch64-linux-gnu-g++**: C++ compiler for AArch64 architecture.
- **aarch64-linux-gnu-as**: Assembly compiler for AArch64 architecture.
- **qemu-aarch64**: Emulator to run the AArch64 binary.
- **gdb-multiarch**: Debugger for cross-platform debugging.
- **/usr/aarch64-linux-gnu**: AArch64 interpreter path.

## Usage

1. Copy this Makefile into your project directory.
2. Run the following command to set up the environment:

    ```bash
    make setup
    ```

    This will create the required directory structure (`src/cpp-files`, `src/asm-files`, and `obj`) and generate default sample files (`main.cpp` and `assembly_func.s`).

3. Place your C++ files into the `src/cpp-files` directory and your assembly files into the `src/asm-files` directory. The Makefile will automatically compile and assemble these files.

4. To build the project, run:

    ```bash
    make
    ```

    This will compile, assemble, link, and create the final binary in the `bin` directory.

## Available Targets

- **all**: Compile, assemble, and link the project. (This is the default target when you run `make`).
- **setup**: Set up the environment by creating necessary directories and files (`main.cpp` and `assembly_func.s`).
- **run**: Run the binary using the AArch64 emulator.
- **debug**: Run the binary in debugging mode and wait for a GDB connection.
- **connect**: Start a GDB session and connect to the QEMU debugger.
- **clean**: Clean the environment by removing object files and the binary.

## Customizing the Build

- You can place any `.cpp` files into the `src/cpp-files` directory and any `.s` files into the `src/asm-files` directory. These files will automatically be compiled and assembled when you run `make`.
  
## Debugging

- To run the binary with GDB, use the `debug` target. It will start the QEMU emulator in debugging mode and wait for a GDB connection on port `1234`.

    To connect GDB to the debugger, run:

    ```bash
    make connect
    ```

## Cleaning the Build

- To remove all generated files (object files and the binary), run:

    ```bash
    make clean
    ```

## Notes

- You can see the available targets and their descriptions by running:

    ```bash
    make help
    ```
