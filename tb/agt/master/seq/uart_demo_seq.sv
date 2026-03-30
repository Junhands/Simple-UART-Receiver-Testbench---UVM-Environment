/*
 * =====================================================
 * Created on Mon Mar 30 2026
 * University of Information Technology (UIT)
 * Copyright (c) 2026 Cong Nguyen
 * Email: congnguyen1024@gmail.com
 * =====================================================
 */

class uart_demo_seq #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_sequence #(REQ,RSP);

  `uvm_object_param_utils(uart_demo_seq #(REQ,RSP))

  string my_name;

  integer drain_time = DRAIN_TIME;
  integer num_write = NUM_WRITE;

  uart_cfg uart_cfg_h;

  //
  // NEW
  //
  function new(string name = "uart_demo_seq");
    super.new(name);
  endfunction

  //
  // BODY
  //
  task body();
    REQ req_pkt;
    RSP rsp_pkt;
    bit [7:0] masked_wdata;

    my_name = get_name();

    assert(uvm_resource_db#(uart_cfg)::read_by_name(get_full_name(),"TB_CONFIG", uart_cfg_h));

    if(uart_cfg_h != null) begin
      uart_cfg_h.set_mask();
      assert(uart_cfg_h.randomize() with {num_write == (num_write & uart_cfg_h.mask);});
      num_write = uart_cfg_h.num_write;
      drain_time = uart_cfg_h.drain_time;
    end
    else begin
    	`uvm_error(my_name,"Could not get a handle to the sequence config")
    end
    `uvm_info("uart_demo_seq: ",$psprintf("num_write = %d, drain_time=%d",num_write,drain_time),UVM_MEDIUM)
    for(int i = 0; i < num_write; i++) begin
      `uvm_info(my_name, $sformatf("Starting write transaction #%0d", i), UVM_LOW)
      // -------------------------------------------------------------
      // Transaction 1: RESET
      // -------------------------------------------------------------
      // send reset transaction
      req_pkt = REQ::type_id::create($sformatf("reset_req"));
      req_pkt.do_reset = 1;
      req_pkt.do_wait = 0;
      start_item(req_pkt);
      finish_item(req_pkt);
      get_response(rsp_pkt);

      // -------------------------------------------------------------
      // Transaction 2: Send write data transactions
      // -------------------------------------------------------------
      req_pkt = REQ::type_id::create($sformatf("tx_wdata_req"));
      assert(req_pkt.randomize());
      req_pkt.do_reset = 0;
      req_pkt.do_wait = 0;
      req_pkt.wr_rd  = 1;

      start_item(req_pkt);
      `uvm_info(my_name, $sformatf("Sent write data: 0x%h", req_pkt.wdata), UVM_LOW)
      finish_item(req_pkt);
      get_response(rsp_pkt);
      // `uvm_info(my_name, $sformatf("Received write data: 0x%h", rsp_pkt.wdata), UVM_LOW)


      // -------------------------------------------------------------
      -> uart_cfg_h.sample_e; // PHASE3 step2

      #100ns;
    end
  endtask
endclass