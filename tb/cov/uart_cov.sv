/*
 * =====================================================
 * Created on Mon Mar 30 2026
 * University of Information Technology (UIT)
 * Copyright (c) 2026 Cong Nguyen
 * Email: congnguyen1024@gmail.com
 * =====================================================
 */
class uart_cov #(type REQ = uvm_sequence_item) extends uvm_component;
    `uvm_component_param_utils(uart_cov #(REQ))

    string my_name;

    typedef ap_queue #(REQ) ap_queue_t;
    ap_queue_t cov_queue;

    bit [7:0] wdata;
    covergroup uart_cov_grp;
        data_cov: coverpoint wdata{
            bins data_00 = {8'h00};
            bins data_7F = {8'h7F};
            bins data_80 = {8'h80};
            bins data_FF = {8'hFF};
        }
    endgroup

    function new(string name, uvm_component parent);
        super.new(name, parent);
        uart_cov_grp = new();
    endfunction

    function void build;
        super.build();
        my_name=get_name();
        cov_queue = ap_queue_t::type_id::create($psprintf("%ss_cov_queue", my_name), this);
    endfunction

    task run;
        REQ pkt;
        forever begin
            @(cov_queue.trigger_e);
            pkt = cov_queue.get_next_tlm();
            `uvm_info(my_name, $psprintf("Sampling: 0x%02h", pkt.wdata), UVM_NONE)
            wdata = pkt.wdata;
            uart_cov_grp.sample();
        end
    endtask
endclass