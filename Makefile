# Hardware Tetris Makefile

# Directories
RTL_DIR = rtl
TB_DIR = tb
BUILD_DIR = build
DOCS_DIR = docs

# Source files
RTL_SRCS = $(wildcard $(RTL_DIR)/*.v)
TB_SRCS = $(wildcard $(TB_DIR)/*.v)

# Tools
IVERILOG = iverilog
VVP = vvp

# Target executable
TARGET = $(BUILD_DIR)/tetris_top.vvp

# Default target
all: build_top

# Compile all RTL files to generate the final system module
build_top: $(RTL_SRCS)
	@mkdir -p $(BUILD_DIR)
	$(IVERILOG) -o $(TARGET) $(RTL_SRCS)
	@echo "Build successful! Executable generated at $(TARGET)"

# Example target for running a testbench (e.g., make sim_input)
sim_input: $(RTL_DIR)/Input_Processing.v $(TB_DIR)/tb_Input_Processing.v
	@mkdir -p $(BUILD_DIR)
	$(IVERILOG) -o $(BUILD_DIR)/tb_Input_Processing.vvp $(RTL_DIR)/Input_Processing.v $(TB_DIR)/tb_Input_Processing.v
	$(VVP) $(BUILD_DIR)/tb_Input_Processing.vvp

# Clean build directory
clean:
	rm -rf $(BUILD_DIR)/*
	@echo "Cleaned build directory."

.PHONY: all build_top sim_input clean
