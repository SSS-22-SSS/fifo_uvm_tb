//------------------------------------------------------------------
// fifo_if.sv
// DUT interface. Remove/skip this file if fifo_if is already
// declared alongside your DUT.
//------------------------------------------------------------------
interface fifo_if;
  logic       clk;
  logic       reset;
  logic       wr;
  logic       rd;
  logic [7:0] din;
  logic [7:0] dout;
  logic       empty;
  logic       full;
endinterface
