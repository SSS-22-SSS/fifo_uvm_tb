//------------------------------------------------------------------
// driver.sv
//------------------------------------------------------------------
class driver extends uvm_driver #(transaction);
  `uvm_component_utils(driver)

  virtual fifo_if fif;

  function new(string name = "driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual fifo_if)::get(this, "", "fif", fif))
      `uvm_fatal("DRV", "Virtual interface not set")
  endfunction

  task reset();
    fif.reset <= 1'b1;
    fif.wr    <= 1'b0;
    fif.rd    <= 1'b0;
    fif.din   <= 8'h00;
    repeat (5) @(posedge fif.clk);
    fif.reset <= 1'b0;
    `uvm_info("DRV", "Reset Done", UVM_LOW)
  endtask

  task write(transaction tr);
    @(posedge fif.clk);
    fif.reset <= 0;
    fif.wr    <= 1;
    fif.rd    <= 0;
    fif.din   <= tr.din;
    @(posedge fif.clk);
    fif.wr    <= 0;
    `uvm_info("DRV", $sformatf("data write:%0d", tr.din), UVM_MEDIUM)
    @(posedge fif.clk);
  endtask

  task read();
    @(posedge fif.clk);
    fif.reset <= 0;
    fif.wr    <= 0;
    fif.rd    <= 1;
    @(posedge fif.clk);
    fif.rd    <= 0;
    `uvm_info("DRV", "data read", UVM_MEDIUM)
    @(posedge fif.clk);
  endtask

  task run_phase(uvm_phase phase);
    transaction tr;
    reset();
    forever begin
      seq_item_port.get_next_item(tr);
      if (tr.oper == 1) write(tr);
      else              read();
      seq_item_port.item_done();
    end
  endtask
endclass
