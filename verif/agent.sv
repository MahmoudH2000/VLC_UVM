class agent #(type MON      = uvm_monitor, 
              type DRV      = uvm_driver,
              type VIF      = virtual vlc_if,
              type SEQR     = uvm_sequencer,
              type SEQ_ITEM = uvm_sequence_item) extends uvm_agent;

    //==================================================================================
    `uvm_component_param_utils(agent#(MON, DRV, VIF, SEQR, SEQ_ITEM))

    //==================================================================================
    MON  mon;
    DRV  drv;
    VIF  vif;
    SEQR seqr;
    uvm_analysis_port #(SEQ_ITEM) agent_ap;

    //==================================================================================
    function new(string name="agent", uvm_component parent=null);
        super.new(name, parent);
    endfunction //new()

    //==================================================================================
    virtual function void build_phase(uvm_phase phase);
        `LOGD(("entered build phase"))
        super.build_phase(phase);
        
        agent_ap = new("agent_ap", this);

      	if (!uvm_config_db#(VIF)::get(this, "", "vif", vif)) begin
            `LOGF(("get vif failed"))
        end

      	if (!uvm_config_db#(uvm_active_passive_enum)::get(this, "", "is_active", is_active)) begin
            `LOGF(("get is_active failed"))
        end

        if (is_active == UVM_ACTIVE) begin
            drv  = DRV::type_id::create("drv", this);
            seqr = SEQR::type_id::create("seqr", this);
        end

        mon  = MON::type_id::create("mon", this);
        
        `LOGD(("exited build phase"))
    endfunction

    //==================================================================================
    virtual function void connect_phase(uvm_phase phase);
        `LOGD(("entered connect phase"))
        super.connect_phase(phase);

        if (is_active == UVM_ACTIVE) begin
            drv.seq_item_port.connect(seqr.seq_item_export);
            drv.vif = vif;
        end

        mon.mon_ap.connect(agent_ap);
        mon.vif = vif;

        `LOGD(("exited connect phase")) 
    endfunction


endclass //vlc_agent #(type MON, DRV)