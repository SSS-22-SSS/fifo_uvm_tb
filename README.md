# FIFO UVM Testbench

A UVM verification environment for a synchronous FIFO, converted from a
mailbox/event-based SystemVerilog testbench.

## Structure

```
.
├── dut/
│   └── README.md          # notes on the expected DUT port list (add fifo.sv here)
├── src/
│   ├── fifo_if.sv          # DUT interface
│   ├── fifo_pkg.sv         # package that includes everything below, in compile order
│   ├── transaction.sv       # uvm_sequence_item
│   ├── sequences/
│   │   ├── fifo_rand_seq.sv   # random 50/50 read-write mix
│   │   ├── fifo_write_seq.sv  # writes only (fill the FIFO)
│   │   └── fifo_read_seq.sv   # reads only (drain the FIFO)
│   ├── driver.sv
│   ├── monitor.sv
│   ├── scoreboard.sv
│   ├── agent.sv
│   ├── env.sv
│   └── fifo_test.sv         # runs write_seq -> read_seq -> rand_seq
├── tb/
│   └── tb_top.sv            # top module: clock, DUT instance, run_test()
└── sim/
    ├── filelist.f           # compile order for the simulator
    └── Makefile              # vcs / questa / xcelium targets
```

## Running

Add your DUT as `dut/fifo.sv` (see `dut/README.md` for the expected port
list), then from `sim/`:

```sh
make vcs       # or: make questa / make xcelium
```

Override the test or verbosity with:

```sh
make vcs TEST=fifo_test
```

## Design notes

- **Driver** only pulls items from the sequencer and drives pins (`fif.wr`,
  `fif.rd`, `fif.din`) based on `tr.oper`. It has no scenario logic.
- **Scenario logic lives in sequences**, not the transaction or driver:
  `fifo_rand_seq` is the original random mix, `fifo_write_seq` /
  `fifo_read_seq` are directed sequences used to fill and drain the FIFO so
  the `full`/`empty` paths are exercised directly rather than left to chance.
- **Scoreboard** mirrors the expected FIFO contents in a queue and compares
  against `dout` on every read, reporting a final error count in
  `report_phase`.
