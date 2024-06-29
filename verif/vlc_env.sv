`include "tb_defines.sv"
`include "vlc_agent_pkg.sv"
import vlc_agent_pkg::*;
`include "vlc_sb.sv"
`include "vlc_vseqr.sv"

class vlc_env extends uvm_env;

    //==================================================================================
    `uvm_component_utils(vlc_env)
    
    //==================================================================================
    vlc_rst_agent  rst_agent;
    vlc_main_agent main_agent;
    vlc_sb         sb;
  	vlc_vseqr      vseqr;

    //==================================================================================
    function new(string name="vlc_env", uvm_component parent=null);
        super.new(name, parent);
    endfunction //new()

    //==================================================================================
    virtual function void build_phase(uvm_phase phase);
        `LOGD(("entered build phase"))
      super.build_phase(phase);
        
        // create agents
        rst_agent  = vlc_rst_agent::type_id::create("rst_agent", this);
        main_agent = vlc_main_agent::type_id::create("main_agent", this);
        uvm_config_db#(uvm_active_passive_enum)::set(this, "main_agent", "is_active", UVM_ACTIVE);
        uvm_config_db#(uvm_active_passive_enum)::set(this, "rst_agent", "is_active", UVM_ACTIVE);

        // create scoreboard
        sb = vlc_sb::type_id::create("sb", this);

      	// create vitual sequencer
        vseqr = vlc_vseqr::type_id::create("vseqr", this);

        `LOGD(("exited build phase"))
    endfunction

    //==================================================================================
    virtual function void connect_phase(uvm_phase phase);
        `LOGD(("entered connect phase"))
      super.connect_phase(phase);
		
      	vseqr.rst_seqr  = rst_agent.seqr;
        vseqr.main_seqr = main_agent.seqr;
      
        main_agent.agent_ap.connect(sb.main_analysis_export);
        rst_agent.agent_ap.connect(sb.rst_analysis_export);

        `LOGD(("exited connect phase"))
    endfunction

endclass //vlc_env