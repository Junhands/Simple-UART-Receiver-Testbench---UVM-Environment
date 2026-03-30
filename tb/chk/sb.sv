/*
 * =====================================================
 * Created on Mon Mar 30 2026
 * University of Information Technology (UIT)
 * Copyright (c) 2026 Cong Nguyen
 * Email: congnguyen1024@gmail.com
 * =====================================================
 */
class sb #(type REQ = uvm_sequence_item) extends uvm_scoreboard;
    `uvm_component_param_utils(sb #(REQ))

    // uvm_analysis_imp_ref_ob_imp #(REQ, sb #(REQ)) ref_ob_imp;
    // uvm_analysis_imp_act_ob_imp #(REQ, sb #(REQ)) act_ob_imp;

    typedef ap_queue #(REQ) ap_queue_t;
    ap_queue_t ref_ap_q;
    ap_queue_t act_ap_q;

    int  pass_cnt = 0;
    int  fail_cnt = 0;
    string my_name;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        my_name = get_name();
    endfunction

    // Chuyển tạo port sang build_phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ref_ap_q = ap_queue #(REQ)::type_id::create("ref_ap_q", this);
        act_ap_q = ap_queue #(REQ)::type_id::create("act_ap_q", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            // Chờ một trong 2 queue có data
            @( act_ap_q.trigger_e);
            
            try_compare();
        end
    endtask


    // So sánh khi cả 2 queue đều có data
    local function void try_compare();
        REQ ref_pkt, act_pkt;



        ref_pkt = ref_ap_q.get_next_tlm();
        act_pkt = act_ap_q.get_next_tlm();
        if (!ref_ap_q.has_data() || !act_ap_q.has_data())
            return;
        if (ref_pkt.wdata == act_pkt.wdata) begin
            pass_cnt++;
            `uvm_info(my_name, $sformatf(
                "PASS [%0d] ref=0x%02h act=0x%02h",
                pass_cnt, ref_pkt.wdata, act_pkt.wdata), UVM_MEDIUM)
        end
        else begin
            fail_cnt++;
            `uvm_error(my_name, $sformatf(
                "FAIL [%0d] ref=0x%02h act=0x%02h",
                fail_cnt, ref_pkt.wdata, act_pkt.wdata))
        end
    endfunction


    virtual function void report_phase(uvm_phase phase);
        if (ref_ap_q.get_size() != 0)
            `uvm_error(my_name, $sformatf(
                "%0d ref packets unmatched", ref_ap_q.get_size()))
        if (act_ap_q.get_size() != 0)
            `uvm_error(my_name, $sformatf(
                "%0d act packets unmatched", act_ap_q.get_size()))

        `uvm_info(my_name, $sformatf(
            "\n==============\n  SCOREBOARD SUMMARY\n  Pass : %0d\n  Fail : %0d\n==============",
            pass_cnt, fail_cnt), UVM_NONE)
    endfunction


endclass
