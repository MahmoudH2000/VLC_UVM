class vlc_base_test extends uvm_test;

    //==================================================================================
    `uvm_component_utils(base_test)
    
    //==================================================================================
    vlc_env  env;
    vlc_vseq vseq;
    vlc_rst_seq rst_seq;

    //==================================================================================
    function new(string name="vlc_base_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction //new()

    //==================================================================================
    virtual function build_phase(uvm_phase phase);
        `LOGN(("build phase starts..."))
        super.build_phase(phase)

        env = vlc_env::type_id::create("env", this);

        `LOGN(("build phase ends..."))
    endfunction

    //==================================================================================
    virtual function start_of_simulation_phase(uvm_phase phase);
        `LOGN(("start_of_simulation phase starts..."))
        super.start_of_simulation_phase(phase);
        if (uvm_report_enabled(UVM_MEDIUM)) begin
            uvm_root::get().print_topology();
        end
        if (uvm_report_enabled(UVM_MEDIUM)) begin
            uvm_factory::get().print();
        end
        `LOGN(("start_of_simulation phase ends..."))
    endfunction

    //==================================================================================
    virtual function reset_phase(uvm_phase phase);
        `LOGN(("reset phase starts..."))
        super.reset_phase(phase);
        rst_seq = vlc_rst_seq::type_id::create("rst_seq");
        rst_seq.start(env.vlc_vseqr);
        `LOGN(("reset phase ends..."))
    endfunction

    //==================================================================================
    virtual function main_phase(uvm_phase phase);
        `LOGN(("main phase starts..."))
        super.main_phase(phase);
        vseq = vseq::type_id::create("vseq");
        vseq.start(env.vlc_vseqr);
        `LOGN(("main phase ends..."))
    endfunction


endclass //base_test