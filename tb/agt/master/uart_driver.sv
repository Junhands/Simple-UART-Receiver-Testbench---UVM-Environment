/*
 * =====================================================
 * Created on Fri Mar 27 2026
 * University of Information Technology (UIT)
 * Copyright (c) 2026 Cong Nguyen
 * Email: congnguyen1024@gmail.com
 * =====================================================
 */

class uart_driver #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_driver #(REQ,RSP);

  `uvm_component_param_utils(uart_driver #(REQ,RSP))

  string my_name;
  integer rsp_pkt_cnt;

  virtual interface uart_if uart_vif;
  virtual interface clk_rst_if clk_rst_vif;
  uart_cfg uart_cfg_h;

  uvm_analysis_port #(REQ) ref_ob_ap;
  uvm_analysis_port #(REQ) cov_ap;
  //
  // NEW
  //
  function new(string name, uvm_component parent);
     super.new(name,parent);
     my_name = get_name();
  endfunction

  //
  // BUILD phase
  //
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ref_ob_ap = new($psprintf("%s_ref_ob_ap", my_name),this);
    cov_ap    = new($psprintf("%s_cov_ap", my_name), this);
  endfunction

  //
  // CONNECT phase
  // Retrieve a handle to the uart_if and uart_cfg
  //
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if(!uvm_config_db#(virtual uart_if)::get(this,"", "UART_VIF", uart_vif)) begin
      `uvm_error(my_name, "Could not retrieve virtual uart_if")
    end
    if(!uvm_config_db#(virtual clk_rst_if)::get(this,"","CLK_RST_VIF",clk_rst_vif)) begin
      `uvm_error(my_name, "Could not retrieve virtual clk_rst_if")
    end
    if(!uvm_config_db#(uart_cfg)::get(this,"","TB_CONFIG", uart_cfg_h)) begin
      `uvm_error(my_name, "Could not retrieve TB_CONFIG");
    end
  endfunction
  //
  // RUN phase
  // Retrieve a transaction packet and act on it:
  //
  virtual task run_phase(uvm_phase phase);
    REQ req_pkt;
    RSP rsp_pkt;
    forever @(posedge uart_vif.clk) begin
      seq_item_port.get_next_item(req_pkt);
      if(req_pkt == null) begin
        continue;
      end
      if(req_pkt.do_reset) begin
        clk_rst_vif.do_reset(5);
      end
      else if(req_pkt.do_wait) begin
        clk_rst_vif.do_wait(5);
      end
      else if(req_pkt.wr_rd) begin
        // ref_ob_ap.write(req_pkt); // after receiving a write packet 
        ref_ob_ap.write(req_pkt);    // observe the write packet for reference checking
        cov_ap.write(req_pkt);     // observe the write packet for coverage
        send_write_packet(req_pkt);
      end
      // else begin
      //   send_read_packet(req_pkt);
      // end

      rsp_pkt_cnt++;
      rsp_pkt = RSP::type_id::create($psprintf("rsp_pkt_id_%d",rsp_pkt_cnt));
      rsp_pkt.set_id_info(req_pkt);
      rsp_pkt.copy(req_pkt);
      seq_item_port.item_done(rsp_pkt);
    end //forever loop
  endtask

  virtual task send_write_packet(REQ req_pkt);
      wait(!uart_vif.rst);

      // Start bit
      uart_vif.driver_cb.i_Rx_Serial <= 1'b0;
      repeat(uart_cfg_h.CLKS_PER_BIT) @(uart_vif.driver_cb);

      // 8 data bits — LSB first
      for (int i = 0; i < 8; i++) begin
          uart_vif.driver_cb.i_Rx_Serial <= req_pkt.wdata[i];
          repeat(uart_cfg_h.CLKS_PER_BIT) @(uart_vif.driver_cb);
      end

      // Stop bit
      uart_vif.driver_cb.i_Rx_Serial <= 1'b1;
      repeat(uart_cfg_h.CLKS_PER_BIT) @(uart_vif.driver_cb);
  endtask

  // PHASE 1 don't need this task //
//====================================//
  // virtual task send_read_packet(REQ req_pkt);
  //   wait(uart_vif.PRESETN);
  //   @(posedge uart_vif.PCLK) begin
  //     uart_vif.PWRITE <= 1'b0;
  //     uart_vif.PSEL <= 1'b1;
  //     uart_vif.PENABLE <= 1'b0;
  //     uart_vif.PADDR <= req_pkt.addr;
  //   end

  //   @(posedge uart_vif.PCLK)
  //   uart_vif.PENABLE <= 1'b1;

  //   wait(uart_vif.PREADY)
  //   @(posedge uart_vif.PCLK) begin
  //     uart_vif.PENABLE <= 1'b0;
  //     uart_vif.PSEL <= 1'b0;
  //   end
  // endtask

endclass

