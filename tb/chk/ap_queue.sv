/*
 * =====================================================
 * Created on Mon Mar 30 2026
 * University of Information Technology (UIT)
 * Copyright (c) 2026 Cong Nguyen
 * Email: congnguyen1024@gmail.com
 * =====================================================
 */
class ap_queue #(type REQ = uvm_sequence_item) extends uvm_subscriber #(REQ);

    `uvm_component_param_utils(ap_queue #(REQ))

    string my_name;
    REQ q[$];
    event trigger_e;

    //
    // NEW
    //
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction

    function integer get_size;
        return q.size();
    endfunction

    function bool_t has_data;
        if (q.size() == 0)
            has_data = IS_FALSE;
        else
            has_data = IS_TRUE;
    endfunction

    function REQ get_next_tlm();
        if(q.size() == 0) begin
            get_next_tlm = null;
        end
        else begin
            get_next_tlm = q.pop_back();
        end
    endfunction

    function void write(REQ t);
        q.push_front(t);
        // `uvm_info(my_name, $sformatf("Received TLM: 0x%02h", t.wdata), UVM_NONE)
        -> trigger_e;
    endfunction
endclass