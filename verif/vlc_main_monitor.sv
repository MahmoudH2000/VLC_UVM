class vlc_main_monitor extends uvm_monitor;

    //==================================================================================
    `uvm_component_param_utils(vlc_main_monitor)
    
    //==================================================================================
    virtual vlc_if vif;
    vlc_seq_item in_xn;
    uvm_analysis_port #(vlc_seq_item) mon_ap;

    //==================================================================================
    function new(string name="main_monitor", uvm_component parent=null);
       super.new(name, parent);
    endfunction //new()

    //==================================================================================
    virtual task build_phase(uvm_phase phase);
        super.build_phase(phase);
        xn = vlc_seq_item::type_id::create("xn");
        mon_ap = new("mon_in_ap", this);
    endtask

    //==================================================================================
    virtual task run_phase(uvm_phase phase);
        `LOGD(("entered main phase"))
        super.run_phase(phase);
        fork
            monitor()
        join_none
        `LOGD(("exited main phase"))
    endtask

    //==================================================================================
    virtual task monitor();
        @(vif.cb_mon)
        forever begin
            monitor_bus();
            @(vif.cb_mon);
        end
    endtask

    //==================================================================================
    virtual task monitor_bus();
        xn.din_valid  = vif.cb_mon.din_valid;
        xn.data_in    = vif.cb_mon.data_in;
        xn.dout_valid = vif.cb_mon.dout_valid;
        xn.data_out   = vif.cb_mon.data_out;
        mon_ap.write(xn);
    endtask

endclass //main_monitor 