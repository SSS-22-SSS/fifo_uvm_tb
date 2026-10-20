# DUT

`fifo.sv` is a 16-deep, 8-bit-wide synchronous FIFO with `wr`/`rd` write/read
strobes and `full`/`empty` status flags. Its ports match what
`tb/tb_top.sv` instantiates:

```
module fifo (
  input      clk, reset, wr, rd,
  input      [7:0] din,
  output reg [7:0] dout,
  output     empty, full
);
```

If you swap in a different FIFO implementation, keep this port list (or
update `tb/tb_top.sv` to match the new one).
