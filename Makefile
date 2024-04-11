FLAGS       := -g2012

setup:
	@mkdir -p work

iverilog: setup
	iverilog -o work/async_fifo $(FLAGS) -f config/tb_filelist.f -f config/rtl_filelist.f

vvp: setup
	vvp work/async_fifo
