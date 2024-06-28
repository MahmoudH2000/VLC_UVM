import vlc_agent_pkg::*;
`include "vlc_vseqr.sv"

class vlc_env extends uvm_env;

    //==================================================================================
    `uvm_component_utils(vlc_env)
    
    //==================================================================================
    vlc_vseqr      vseqr;
    vlc_rst_agent  rst_agent;
    vlc_main_agent main_agent;
    vlc_sb         sb;

    //==================================================================================
    function new(string name="vlc_env", uvm_component parent=null);
        super.new(name, parent);
    endfunction //new()

    //==================================================================================
    virtual task build_phase(uvm_phase phase);
        `LOGD(("entered build phase"))
        super.build_phase(phase)
        
        // create agents
        rst_agent  = vlc_rst_agent::type_id::create("rst_agent", this);
        main_agent = vlc_main_agent::type_id::create("main_agent", this);

        // create scoreboard
        sb = vlc_sb:type_id::create("sb", this);
        
        // create vitual sequencer
        vseqr = vlc_vseqr::type_id::create(:"vseqr", this);

        `LOGD(("exited build phase"))
    endtask

    //==================================================================================
    virtual task connect_phase(uvm_phase phase);
        `LOGD(("entered connect phase"))
        super.connect_phase(phase)

        vseqr.rst_seqr  = rst_agent.seqr;
        vseqr.main_seqr = main_agent.seqr;

        main_agent.agent_ap.connect(sb.main_analysis_export);
        rst_agent.agent_ap.connect(sb.rst_analysis_export);

        `LOGD(("exited connect phase"))
    endtask

endclass //vlc_env