class vlc_rst_monitor extends uvm_monitor;

    //==================================================================================
    `uvm_component_param_utils(vlc_rst_monitor)
    
    //==================================================================================
    virtual vlc_if vif;
    vlc_seq_item xn;
    uvm_analysis_port #(vlc_seq_item) mon_ap;

    //==================================================================================
    function new(string name="rst_monitor", uvm_component parent=null);
       super.new(name, parent);
    endfunction //new()

    //==================================================================================
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        xn = vlc_seq_item::type_id::create("xn");
        mon_ap = new("mon_ap", this);
    endfunction

    //==================================================================================
    virtual task run_phase(uvm_phase phase);
        `LOGD(("entered main phase"))
        super.run_phase(phase);
        fork
            monitor();
        join_none
        `LOGD(("exited main phase"))
    endtask

    //==================================================================================
    virtual task monitor();
        @(vif.cb_rst_mon)
        forever begin
            monitor_bus();
            @(vif.cb_rst_mon);
        end
    endtask

    //==================================================================================
    virtual task monitor_bus();
        if (!vif.cb_rst_mon.rst) begin
            mon_ap.write(xn);
        end
    endtask

endclass // rst_monitor