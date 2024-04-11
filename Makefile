FLAGS       := -g2012

setup:
	@mkdir -p work

iverilog: setup
	iverilog -o work/async_fifo $(FLAGS) -c config/filelist.f

vvp: setup
	cd work && vvp async_fifo
