//------------------------------------------------------------------
// fifo_rand_seq.sv
// Base random mix - equivalent to the original generator.
//------------------------------------------------------------------
class fifo_rand_seq extends uvm_sequence #(transaction);
  `uvm_object_utils(fifo_rand_seq)

  int count = 35;

  function new(string name = "fifo_rand_seq");
    super.new(name);
  endfunction

  task body();
    transaction tr;
    repeat (count) begin
      tr = transaction::type_id::create("tr");
      start_item(tr);
      // 50/50 read/write mix, same as the old oper_ctrl constraint
      if (!tr.randomize() with { oper dist {0 := 50, 1 := 50}; })
        `uvm_error("SEQ", "Randomization failed")
      finish_item(tr);
      `uvm_info("GEN", $sformatf("oper:%0d", tr.oper), UVM_MEDIUM)
    end
  endtask
endclass
