//------------------------------------------------------------------
// env.sv
//------------------------------------------------------------------
class env extends uvm_env;
  `uvm_component_utils(env)

  agent      agt;
  scoreboard sco;

  function new(string name = "env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt = agent::type_id::create("agt", this);
    sco = scoreboard::type_id::create("sco", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    agt.mon.ap.connect(sco.imp);
  endfunction
endclass
