class vlc_main_driver extends uvm_driver#(vlc_seq_item);

    //==================================================================================
    `uvm_component_param_utils(vlc_main_driver)
    
    //==================================================================================
    virtual vlc_if vif;

    //==================================================================================
    function new(string name="main_driver", uvm_component parent=null);
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
        @(vif.cb_drv)
        forever begin
            seq_item_port.get_next_item(req);
            drive_bus();
            seq_item_port.item_done();
        end
    endtask

    //==================================================================================
    virtual task drive_bus();
        // drive transaction
        vif.cb_drv.din_valid <= req.data_in;
        vif.cb_drv.din_valid <= 1'b1;
        repeat (req.length) @(vif.cb_drv);

        // stagger
        if (req.stagger) begin
            vif.cb_drv.din_valid <= 1'b0;
            repeat (req.stagger) @(vif.cb_drv); 
        end
    endtask

endclass //main_driver 