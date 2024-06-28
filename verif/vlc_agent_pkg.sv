package vlc_agent_pkg;
    
    `include "vlc_main_driver.sv"
    `include "vlc_main_monitor.sv"
    `include "vlc_rst_driver.sv"
    `include "vlc_rst_monitor.sv"
    `include "vlc_seq_item.sv"

    typedef uvm_sequencer#(vlc_seq_item) sqr;

    typedef agent #(.MON(vlc_main_monitor), 
                    .DRV(vlc_main_driver),
                    .VIF(virtual vlc_if),
                    .SEQR(sqr),
                    .SEQ_ITEM(vlc_seq_item)) vlc_main_agent;

    typedef agent #(.MON(vlc_rst_monitor), 
                    .DRV(vlc_rst_driver),
                    .VIF(virtual vlc_if),
                    .SEQR(sqr),
                    .SEQ_ITEM(vlc_seq_item)) vlc_rst_agent;
typ

endpackage