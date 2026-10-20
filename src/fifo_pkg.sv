//------------------------------------------------------------------
// fifo_pkg.sv
// Package wrapper - keeps the compile order explicit in one place
// instead of relying on `include order at the top-level module.
//------------------------------------------------------------------
package fifo_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  `include "transaction.sv"
  `include "sequences/fifo_rand_seq.sv"
  `include "sequences/fifo_write_seq.sv"
  `include "sequences/fifo_read_seq.sv"
  `include "driver.sv"
  `include "monitor.sv"
  `include "scoreboard.sv"
  `include "agent.sv"
  `include "env.sv"
  `include "fifo_test.sv"
endpackage
