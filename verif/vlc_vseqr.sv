class vlc_vseqr extends uvm_sequencer;
    
    //==================================================================================
    `uvm_component_utils(vlc_vseqr)

    //==================================================================================
    sqr rst_seqr;
    sqr main_seqr;

    //==================================================================================
    function new(string name = "vlc_vseqr", uvm_component parent = null);
        super.new(name, parent);
    endfunction

endclass 