# Simple multi-simulator Makefile for the FIFO UVM testbench.
# Usage:
#   make vcs      # Synopsys VCS
#   make questa   # Siemens QuestaSim
#   make xcelium  # Cadence Xcelium
#   make clean

TOP       = tb_top
TEST      ?= fifo_test
FILELIST  = filelist.f

.PHONY: vcs questa xcelium clean

vcs:
	vcs -full64 -sverilog -ntb_opts uvm -timescale=1ns/1ps \
		-f $(FILELIST) -top $(TOP) -o simv
	./simv +UVM_TESTNAME=$(TEST) +UVM_VERBOSITY=UVM_MEDIUM

questa:
	vlog -sv +incdir+../src +incdir+../src/sequences -f $(FILELIST)
	vsim -c $(TOP) -do "run -all; quit" +UVM_TESTNAME=$(TEST) +UVM_VERBOSITY=UVM_MEDIUM

xcelium:
	xrun -uvm -access +rwc -f $(FILELIST) -top $(TOP) \
		+UVM_TESTNAME=$(TEST) +UVM_VERBOSITY=UVM_MEDIUM

clean:
	rm -rf simv* csrc *.log *.vcd *.vdb work transcript \
		xcelium.d xrun.log xrun.history vsim.wlf
