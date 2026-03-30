/*
 * =====================================================
 * Created on Fri Mar 27 2026
 * University of Information Technology (UIT)
 * Copyright (c) 2026 Cong Nguyen
 * Email: congnguyen1024@gmail.com
 * =====================================================
 */

class uart_cfg extends uvm_object;

  `uvm_object_utils(uart_cfg)
  uvm_table_printer printer;
  event sample_e;

  rand integer drain_time;
  rand integer num_write;

  bit [31:0] mask;
  integer CLKS_PER_BIT = 87;


  function void set_mask();
    mask = 32'h0000000FF;
  endfunction
  //
  // NEW
  //
  function new(string name = "");
    super.new(name);
  endfunction

  function void do_print(uvm_printer printer);
      super.do_print(printer);
      printer.print_field("drain_time", drain_time, $bits(drain_time));
      printer.print_field("num_write", num_write, $bits(num_write));
  endfunction

  constraint default_cfg_c{
    drain_time == DRAIN_TIME;
  }

endclass
