//------------------------------------------------------------------
// fifo_test.sv
//------------------------------------------------------------------
class fifo_test extends uvm_test;
  `uvm_component_utils(fifo_test)

  env env_h;

  function new(string name = "fifo_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env_h = env::type_id::create("env_h", this);
  endfunction

  task run_phase(uvm_phase phase);
    fifo_write_seq wr_seq;
    fifo_read_seq  rd_seq;
    fifo_rand_seq  rnd_seq;

    phase.raise_objection(this);

    // Directed: fill the FIFO, then drain it - exercises the full/empty
    // flags directly rather than hoping random traffic happens to hit them
    wr_seq = fifo_write_seq::type_id::create("wr_seq");
    wr_seq.count = 16;
    wr_seq.start(env_h.agt.seqr);

    rd_seq = fifo_read_seq::type_id::create("rd_seq");
    rd_seq.count = 16;
    rd_seq.start(env_h.agt.seqr);

    // Then general random read/write mix, same as the original testbench
    rnd_seq = fifo_rand_seq::type_id::create("rnd_seq");
    rnd_seq.count = 35;
    rnd_seq.start(env_h.agt.seqr);

    #200;   // drain time so the monitor/scoreboard finish the last transaction
    phase.drop_objection(this);
  endtask
endclass
