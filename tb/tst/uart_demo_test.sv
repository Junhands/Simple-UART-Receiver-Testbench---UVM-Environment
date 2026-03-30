/*
 * =====================================================
 * Created on Mon Mar 30 2026
 * University of Information Technology (UIT)
 * Copyright (c) 2026 Cong Nguyen
 * Email: congnguyen1024@gmail.com
 * =====================================================
 */

// A demo test case.
//***************************************************************************************************************
class uart_demo_test extends uvm_test;

	`uvm_component_utils(uart_demo_test)

  typedef uart_demo_seq#(uart_tlm, uart_tlm) sequence_t;
  typedef uart_env     #(uart_tlm, uart_tlm) env_t;

  sequence_t sequence_h;
  uart_cfg    uart_cfg_h;
  env_t      env_h;
  //
  // NEW
  //
	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction
	
  //
  // BUILD phase
  //
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create an instance of env
    env_h = env_t::type_id::create("uart_env",this);

    // Create an instance of uart_cfg_h
    uart_cfg_h = uart_cfg::type_id::create("uart_cfg");

    // Create an instance of the apb_demo_seq
    sequence_h = sequence_t::type_id::create("apb_demo_seq",this);

    // Use uvm_config_db::set to place uart_cfg_h in the resource database
    uvm_resource_db #(uart_cfg)::set("*", "TB_CONFIG", uart_cfg_h);

  endfunction
  //
  // RUN phase
  //
	task run_phase(uvm_phase phase);

    phase.raise_objection(this,"Objection raised by uart_demo_test");

    sequence_h.start(env_h.uart_master_agent.sequencer); // start the APB sequence

    #50ms; // wait for some time to complete transactions

    phase.drop_objection(this,"Objection dropped by uart_demo_test");
	endtask
	
endclass
   
