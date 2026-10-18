//------------------------------------------------------------------
// fifo_write_seq.sv
// Directed: writes only - e.g. to fill the FIFO up.
//------------------------------------------------------------------
class fifo_write_seq extends uvm_sequence #(transaction);
  `uvm_object_utils(fifo_write_seq)

  int count = 16;

  function new(string name = "fifo_write_seq");
    super.new(name);
  endfunction

  task body();
    transaction tr;
    repeat (count) begin
      tr = transaction::type_id::create("tr");
      start_item(tr);
      if (!tr.randomize() with { oper == 1; })
        `uvm_error("SEQ", "Randomization failed")
      finish_item(tr);
      `uvm_info("GEN", $sformatf("oper:%0d (write)", tr.oper), UVM_MEDIUM)
    end
  endtask
endclass
