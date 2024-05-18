class rst_driver #(type VIF      = virtual vlc_if,
                   type SEQ_ITEM = uvm_sequence_item)  extends uvm_driver#(SEQ_ITEM);

    //==================================================================================
    `uvm_component_param_utils(rst_driver#(VIF, SEQ_ITEM))
    
    //==================================================================================
    VIF vif;

    //==================================================================================
    function new(string name="rst_driver", uvm_component parent=null);
       super.new(name, parent);
    endfunction //new()
    
    //==================================================================================
    virtual function reset_phase(uvm_phase phase);
        `LOGD(("entered reset phase"))
        super.reset_phase(phase);
        fork
            drive();
        join_none
        `LOGD(("exited reset phase"))
    endfunction

    //==================================================================================
    virtual function main_phase(uvm_phase phase);
        `LOGD(("entered main phase"))
        super.main_phase(phase);
        fork
            drive();
        join_none
        `LOGD(("exited main phase"))
    endfunction

    //==================================================================================
    virtual task drive();
        @(vif.cb_rst_drv)
        forever begin
            seq_item_port.get_next_item(req);
            drive_bus(req);
            seq_item_port.item_done();
            @(vif.cb_rst_drv);
        end
    endtask

    //==================================================================================
    virtual task drive_bus();
        vif.cb_rst_drv.rst <= req.rst;
    endtask

endclass //vlc_driver 