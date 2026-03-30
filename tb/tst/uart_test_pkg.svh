/*
 * =====================================================
 * Created on Mon Mar 30 2026
 * University of Information Technology (UIT)
 * Copyright (c) 2026 Cong Nguyen
 * Email: congnguyen1024@gmail.com
 * =====================================================
 */

//***************************************************************************************************************
package uart_test_pkg;

   import uvm_pkg::*;
   import uart_env_pkg::*;
   import uart_cfg_pkg::*;
   import uart_tlm_pkg::*;
   import uart_seq_pkg::*;
   import uvm_tb_udf_pkg::*;
   
   `include "uvm_macros.svh"  
   //
   // All new tests must derive from base_test and must be listed here.
   // Each test is saved as one file
   //
   `include "uart_demo_test.sv"       // single sequence test
endpackage
