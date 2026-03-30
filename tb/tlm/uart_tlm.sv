/*
 * =====================================================
 * Created on Fri Mar 27 2026
 * University of Information Technology (UIT)
 * Copyright (c) 2026 Cong Nguyen
 * Email: congnguyen1024@gmail.com
 * =====================================================
 */

class uart_tlm extends uvm_sequence_item;

 `uvm_object_utils(uart_tlm)

  rand bit[8-1:0] wdata;
  
  bit do_reset;
  bit do_wait;
  bit wr_rd;
  //
  // NEW
  //
  function new(string name = "uart_tlm");
    super.new(name);
  endfunction

  function void do_copy(uvm_object rhs);
    uart_tlm der_type;
    super.do_copy(rhs);
    $cast(der_type,rhs);
    wdata = der_type.wdata;
  endfunction


  constraint default_tlm{
    do_reset == 1'b0;
    do_wait == 1'b0;
    wr_rd == 1'b0;
  }
endclass
