//------------------------------------------------------------------
// tb_top.sv
// Top-level testbench module.
//------------------------------------------------------------------
`include "uvm_macros.svh"

module tb_top;
  import uvm_pkg::*;
  import fifo_pkg::*;

  fifo_if fif();

  // Replace with your actual DUT port connections if they differ
  fifo dut (
    .clk   (fif.clk),
    .reset (fif.reset),
    .wr    (fif.wr),
    .rd    (fif.rd),
    .din   (fif.din),
    .dout  (fif.dout),
    .empty (fif.empty),
    .full  (fif.full)
  );

  initial fif.clk = 0;
  always #10 fif.clk = ~fif.clk;

  initial begin
    uvm_config_db#(virtual fifo_if)::set(null, "*", "fif", fif);
    run_test("fifo_test");
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endmodule
