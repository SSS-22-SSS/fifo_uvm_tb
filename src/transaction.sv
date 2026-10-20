//------------------------------------------------------------------
// transaction.sv
//------------------------------------------------------------------
class transaction extends uvm_sequence_item;
  rand bit       oper;          // 1 -> write, 0 -> read
  rand bit [7:0] din;
  bit            wr, rd;
  bit [7:0]      dout;
  bit            empty, full;

  // Only value-range legality lives here. Which mix of read/write to
  // generate is a scenario decision, so that constraint lives in the
  // sequences (inline "with" constraints), not here.
  constraint din_range { din inside {[1:10]}; }   // same as $urandom_range(1,10)

  `uvm_object_utils_begin(transaction)
    `uvm_field_int(oper,  UVM_ALL_ON)
    `uvm_field_int(wr,    UVM_ALL_ON)
    `uvm_field_int(rd,    UVM_ALL_ON)
    `uvm_field_int(din,   UVM_ALL_ON)
    `uvm_field_int(dout,  UVM_ALL_ON)
    `uvm_field_int(full,  UVM_ALL_ON)
    `uvm_field_int(empty, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "transaction");
    super.new(name);
  endfunction
endclass
