class vlc_rst_driver  extends uvm_driver#(vlc_seq_item);

    //==================================================================================
    `uvm_component_param_utils(vlc_rst_driver)
    
    //==================================================================================
    virtual vlc_if vlc_if vif;

    //==================================================================================
    function new(string name="rst_driver", uvm_component parent=null);
       super.new(name, parent);
    endfunction //new()
    
    //==================================================================================
    virtual task run_phase(uvm_phase phase);
        `LOGD(("entered main phase"))
        super.run_phase(phase);
        fork
            drive();
        join_none
        `LOGD(("exited main phase"))
    endtask

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

endclass //rst_driver 