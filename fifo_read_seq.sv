//------------------------------------------------------------------
// fifo_read_seq.sv
// Directed: reads only - e.g. to drain the FIFO.
//------------------------------------------------------------------
class fifo_read_seq extends uvm_sequence #(transaction);
  `uvm_object_utils(fifo_read_seq)

  int count = 16;

  function new(string name = "fifo_read_seq");
    super.new(name);
  endfunction

  task body();
    transaction tr;
    repeat (count) begin
      tr = transaction::type_id::create("tr");
      start_item(tr);
      if (!tr.randomize() with { oper == 0; })
        `uvm_error("SEQ", "Randomization failed")
      finish_item(tr);
      `uvm_info("GEN", $sformatf("oper:%0d (read)", tr.oper), UVM_MEDIUM)
    end
  endtask
endclass
