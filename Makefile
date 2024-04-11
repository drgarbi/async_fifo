FLAGS       := -g2012

RTL_DIR     := rtl/
RTL_FILES   := $(shell find $(RTL_DIR) -name '*.sv')
VERIF_DIR   := verif/
VERIF_FILES := $(shell find $(VERIF_DIR) -name '*.sv')

setup:
	@mkdir -p work

iverilog: setup
	iverilog -o work/async_fifo $(FLAGS) $(VERIF_FILES) $(RTL_FILES)

vvp: setup
	vvp work/async_fifo
