# Directory for object files
OBJ_DIR = obj
# Directory containing C++ source files
CPP_SRC_DIR = src/cpp-files
# Directory containing assembly source files
ASM_SRC_DIR = src/asm-files
# Directory for the final binary
BINARY = bin
# C++ compiler for AArch64 architecture
CXX = aarch64-linux-gnu-g++
# Assembly compiler for AArch64 architecture
AS = aarch64-linux-gnu-as
# C++ compiler flags (debugging, warnings, optimization)
CXXFLAGS = -g -Wall -Wextra -O3
# Assembly compiler flags (debugging)
ASFLAGS = -g
# Emulator to run the AArch64 binary
EMULATOR = qemu-aarch64
# Path to the AArch64 Libraries
EMULATION_LIB_PATH = /usr/aarch64-linux-gnu
# Debugger
DEBUGGER = gdb-multiarch
# Architecture for gdb
ARCH = aarch64
# Port for the debugging server
DEBUG_PORT = 1234

# Default goal
.DEFAULT_GOAL = help

# Declare phony targets
.PHONY: help all setup run debug clean

# Automatically find .cpp files in the source directory
CPP_SRC = $(wildcard $(CPP_SRC_DIR)/*.cpp)

# Automatically find .s files in the source directory
ASM_SRC = $(wildcard $(ASM_SRC_DIR)/*.s)

# Define object files corresponding to the C++ source files
CPP_OBJS = $(patsubst $(CPP_SRC_DIR)/%.cpp, $(OBJ_DIR)/%.o, $(CPP_SRC))

# Define object files corresponding to the assembly source files
ASM_OBJS = $(patsubst $(ASM_SRC_DIR)/%.s, $(OBJ_DIR)/%.o, $(ASM_SRC))

# Help target to show available targets with descriptions
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	 sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# Main target to build everything: compile, assemble, and link
all: $(BINARY) ## compile, assemble and link

# Link the object files to create the final binary
$(BINARY): $(CPP_OBJS) $(ASM_OBJS) | $(OBJ_DIR)
	$(CXX) $(CXXFLAGS) $(CPP_OBJS) $(ASM_OBJS) -o $(BINARY)

# Compile the C++ source files to object files
$(OBJ_DIR)/%.o: $(CPP_SRC_DIR)/%.cpp | $(OBJ_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Assemble the assembly source files to object files
$(OBJ_DIR)/%.o: $(ASM_SRC_DIR)/%.s | $(OBJ_DIR)
	$(AS) $(ASFLAGS) $< -o $@

# Create the object directory if it doesn't exist
$(OBJ_DIR):
	mkdir $(OBJ_DIR)

# Create a default C++ template file if it doesn't exist
$(CPP_SRC_DIR)/main.cpp: | $(CPP_SRC_DIR)
	@echo '/*' > $@
	@echo ' * @brief   Main file' >> $@
	@echo ' */' >> $@
	@echo '' >> $@
	@echo '#include <iostream>' >> $@
	@echo 'using namespace std;' >> $@
	@echo '' >> $@
	@echo '// Declare external assembly function' >> $@
	@echo 'extern "C" int my_asm_function(int a, int b, int c);' >> $@
	@echo '' >> $@
	@echo 'int main() {' >> $@
	@echo '    int result = my_asm_function(1, 2, 3);' >> $@
	@echo '    cout << "Result from assembly: " << result << endl;' >> $@
	@echo '    return 0;' >> $@
	@echo '}' >> $@

# Create a default assembly template file if it doesn't exist
$(ASM_SRC_DIR)/assembly_func.s: | $(ASM_SRC_DIR)
	@echo '/*' > $@
	@echo ' * @brief   Assembly function for my_asm_function' >> $@
	@echo ' */' >> $@
	@echo '' >> $@
	@echo '.global my_asm_function' >> $@
	@echo 'my_asm_function:' >> $@
	@echo '    mov x0, #0' >> $@
	@echo '    ret' >> $@

# Create the source directories if they don't exist
$(CPP_SRC_DIR):
	mkdir -p $(CPP_SRC_DIR)

$(ASM_SRC_DIR):
	mkdir -p $(ASM_SRC_DIR)

# Setup target to create initial files if they don't exist
setup: $(CPP_SRC_DIR)/main.cpp $(ASM_SRC_DIR)/assembly_func.s ## setup the environment

# Run the binary using the emulator
run: $(BINARY) ## run the binary
	@$(EMULATOR) -L $(EMULATION_LIB_PATH) $(BINARY)

# Debug target to run the binary in debugging mode and wait for gdb connection
debug: $(BINARY)  ## run in debugging mode and wait for gdb connection
	$(EMULATOR) -L $(EMULATION_LIB_PATH) -g $(DEBUG_PORT) $(BINARY)

# Connect target to start a GDB session and connect to the qemu debugger
connect: ## connect gdb
	$(DEBUGGER) -q --nh -ex 'set architecture $(ARCH)' -ex 'file $(BINARY)' -ex 'target remote localhost:$(DEBUG_PORT)' -ex 'layout regs'

# Clean target to remove generated files
clean: ## cleans the environment	
	rm -rf $(OBJ_DIR)
	rm -f $(BINARY)
