//------------------------------------------------------------------
// scoreboard.sv
//------------------------------------------------------------------
class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)

  uvm_analysis_imp #(transaction, scoreboard) imp;

  bit [7:0] din_q[$];
  int       err = 0;

  function new(string name = "scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    imp = new("imp", this);
  endfunction

  function void write(transaction tr);
    bit [7:0] exp;

    `uvm_info("SCO", $sformatf("wr:%0d rd:%0d din:%0d dout:%0d full:%0d empty:%0d",
              tr.wr, tr.rd, tr.din, tr.dout, tr.full, tr.empty), UVM_MEDIUM)

    if (tr.wr) begin
      if (!tr.full) begin
        din_q.push_back(tr.din);
        `uvm_info("SCO", $sformatf("Data pushed to queue:%0d", tr.din), UVM_MEDIUM)
      end
      else `uvm_info("SCO", "FIFO is full", UVM_MEDIUM)
    end

    if (tr.rd) begin
      if (!tr.empty) begin
        exp = din_q.pop_front();
        if (exp == tr.dout)
          `uvm_info("SCO", "Data match", UVM_MEDIUM)
        else begin
          `uvm_error("SCO", $sformatf("Data mismatch: expected %0d, got %0d", exp, tr.dout))
          err++;
        end
      end
      else `uvm_info("SCO", "FIFO is empty", UVM_MEDIUM)
    end
  endfunction

  function void report_phase(uvm_phase phase);
    `uvm_info("SCO", $sformatf("Error count:%0d", err), UVM_NONE)
  endfunction
endclass
