/*
 * =====================================================
 * Created on Fri Mar 27 2026
 * University of Information Technology (UIT)
 * Copyright (c) 2026 Cong Nguyen
 * Email: congnguyen1024@gmail.com
 * =====================================================
 */

class uart_monitor #(type PKT = uvm_sequence_item) extends uvm_monitor;

  `uvm_component_param_utils(uart_monitor #(PKT))

  uvm_analysis_port #(PKT) act_ob_ap;

  virtual interface uart_if uart_vif;
  virtual interface clk_rst_if clk_rst_vif;
  uart_cfg uart_cfg_h;

  bit[7:0] temp_wdata;
  string my_name;
  //
  // NEW
  //
  function new(string name, uvm_component parent);
    super.new(name,parent);
    my_name = get_name();
    act_ob_ap = new($psprintf("%s_act_ob_ap", my_name), this);
  endfunction

  //
  // CONNECT phase
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
  //
  task run_phase(uvm_phase phase);
      PKT uart_pkt;
      // Chờ reset xong — giống driver
      wait(!uart_vif.rst);
      @(uart_vif.monitor_cb);  // sync với clock edge đầu tiên
      forever begin
          // Chờ start bit — i_Rx_Serial kéo xuống 0
          @(negedge uart_vif.i_Rx_Serial);
          // Nhảy đến giữa start bit để confirm
          repeat(uart_cfg_h.CLKS_PER_BIT / 2) @(uart_vif.monitor_cb);
          // Confirm vẫn còn là start bit — không phải glitch
          if (uart_vif.monitor_cb.i_Rx_Serial !== 1'b0) begin
              `uvm_error(get_name(), "False start bit — glitch detected")
              continue;  // bỏ qua, quay lại chờ start bit tiếp
          end
          // Sample 8 data bits tại giữa mỗi bit period
          for (int i = 0; i < 8; i++) begin
              repeat(uart_cfg_h.CLKS_PER_BIT) @(uart_vif.monitor_cb);
              temp_wdata[i] = uart_vif.monitor_cb.i_Rx_Serial;
          end
          // Chờ stop bit
          repeat(uart_cfg_h.CLKS_PER_BIT) @(uart_vif.monitor_cb);
          // Confirm stop bit hợp lệ
          if (uart_vif.monitor_cb.i_Rx_Serial !== 1'b1)
              `uvm_error(get_name(), "Invalid stop bit")
          // Tạo và gửi packet
          uart_pkt = PKT::type_id::create("uart_pkt");
          uart_pkt.wdata = temp_wdata;
          act_ob_ap.write(uart_pkt);
      end
  endtask


endclass
