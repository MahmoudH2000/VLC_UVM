class main_monitor #(type VIF      = virtual vlc_if,
                    type SEQ_ITEM = uvm_sequence_item)  extends uvm_driver;

    //==================================================================================
    `uvm_component_param_utils(main_monitor#(VIF, SEQ_ITEM))
    
    //==================================================================================
    VIF vif;
    SEQ_ITEM xn;
    uvm_analysis_port #(SEQ_ITEM) mon_ap;

    //==================================================================================
    function new(string name="main_monitor", uvm_component parent=null);
       super.new(name, parent);
    endfunction //new()

    //==================================================================================
    virtual function build_phase(uvm_phase phase);
        super.build_phase(phase);
        xn = SEQ_ITEM::type_id::create("xn");
    endfunction
    
    //==================================================================================
    virtual function reset_phase(uvm_phase phase);
        `LOGD(("entered reset phase"))
        super.reset_phase(phase);
        fork
            monitor();
        join_none
        `LOGD(("exited reset phase"))
    endfunction

    //==================================================================================
    virtual function main_phase(uvm_phase phase);
        `LOGD(("entered main phase"))
        super.main_phase(phase);
        fork
            monitor();
        join_none
        `LOGD(("exited main phase"))
    endfunction

    //==================================================================================
    virtual task monitor();
        @(vif.cb_rst_mon)
        forever begin
            monitor_bus();
            mon_ap.write(xn);
            @(vif.cb_rst_mon);
        end
    endtask

    //==================================================================================
    virtual task monitor_bus();
        xn.rst = vif.rst;
    endtask

endclass //vlc_driver 