/*
 * =====================================================
 * Created on Fri Mar 27 2026
 * University of Information Technology (UIT)
 * Copyright (c) 2026 Cong Nguyen
 * Email: congnguyen1024@gmail.com
 * =====================================================
 */

class uart_env #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_env;

   `uvm_component_param_utils(uart_env #(REQ,RSP))

   typedef uart_master_agent#(REQ, RSP)   uart_master_agent_t;
   typedef uart_slave_agent#(REQ,RSP)     uart_slave_agent_t;
   typedef uart_cov#(REQ)                 uart_cov_t;
   typedef sb#(REQ)                       scoreboard_t;

   uart_master_agent_t                    uart_master_agent;
   uart_slave_agent_t                     uart_slave_agent;
   scoreboard_t                           scoreboard;
   uart_cov_t                             cov;
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
      uart_master_agent = uart_master_agent_t::type_id::create("master_agent",this);
      uart_slave_agent  = uart_slave_agent_t::type_id::create("slave_agent",this);
      cov               = uart_cov_t::type_id::create("cov",this);
      scoreboard        = scoreboard_t::type_id::create("scoreboard",this);
   endfunction
   //
   // CONNECT phase
   //
   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      uart_master_agent.ref_ob_ap.connect(scoreboard.ref_ap_q.analysis_export);
      uart_slave_agent.act_ob_ap.connect(scoreboard.act_ap_q.analysis_export);
      uart_master_agent.cov_ap.connect(cov.cov_queue.analysis_export);
   endfunction
endclass
