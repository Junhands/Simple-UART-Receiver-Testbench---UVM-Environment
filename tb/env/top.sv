/*
 * =====================================================
 * Created on Mon Mar 30 2026
 * University of Information Technology (UIT)
 * Copyright (c) 2026 Cong Nguyen
 * Email: congnguyen1024@gmail.com
 * =====================================================
 */

// Top level module. It is responsible for instantiating the dut and the interface modules. It also passes the
// interface handle using set_config_object.
//***************************************************************************************************************
import uvm_pkg::*;

 `timescale 1ns/1ps
module top;
import uart_test_pkg::*;
   
  wire clk;
  wire rst;
   
  //
  // Create interface instances here
  //
  clk_rst_if clk_rst_if0(.clk(clk),.rst(rst));
  uart_if uart_if0(.clk(clk),.rst(rst));
   
  //
  // Create DUT instance
  //
  receiver dut0(
    .i_Clock(clk),
    .i_Rx_Serial(uart_if0.i_Rx_Serial),
    .o_Rx_DV(uart_if0.o_Rx_DV),
    .o_Rx_Byte(uart_if0.o_Rx_Byte)
	);

  initial begin
    // Put interface handles in resource database
    uvm_config_db #(virtual clk_rst_if)::set(null,"*","CLK_RST_VIF",clk_rst_if0);
    uvm_config_db #(virtual uart_if)::set(null,"*","UART_VIF",uart_if0);
    // Run test
    run_test();
  end

endmodule
