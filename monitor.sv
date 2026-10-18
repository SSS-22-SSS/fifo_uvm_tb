//------------------------------------------------------------------
// monitor.sv
//------------------------------------------------------------------
class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)

  virtual fifo_if fif;
  uvm_analysis_port #(transaction) ap;

  function new(string name = "monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap = new("ap", this);
    if (!uvm_config_db#(virtual fifo_if)::get(this, "", "fif", fif))
      `uvm_fatal("MON", "Virtual interface not set")
  endfunction

  task run_phase(uvm_phase phase);
    transaction tr;
    forever begin
      @(posedge fif.clk);
      // A wr/rd request is seen at this clock edge
      if (!fif.reset && (fif.wr || fif.rd)) begin
        tr       = transaction::type_id::create("tr");
        tr.wr    = fif.wr;
        tr.rd    = fif.rd;
        tr.din   = fif.din;
        tr.full  = fif.full;
        tr.empty = fif.empty;
        // dout becomes valid one clock after the read edge
        @(posedge fif.clk);
        tr.dout  = fif.dout;
        `uvm_info("MON", $sformatf("wr:%0d rd:%0d din:%0d dout:%0d full:%0d empty:%0d",
                  tr.wr, tr.rd, tr.din, tr.dout, tr.full, tr.empty), UVM_MEDIUM)
        ap.write(tr);
      end
    end
  endtask
endclass
