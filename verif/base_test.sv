`include "vlc_env.sv"
`include "vlc_main_seq.sv"
`include "vlc_rst_seq.sv"

class vlc_base_test extends uvm_test;

    //==================================================================================
    `uvm_component_utils(vlc_base_test)
    
    //==================================================================================
    vlc_env  env;
    vlc_main_seq vseq;
    vlc_rst_seq rst_seq;

    //==================================================================================
    function new(string name="vlc_base_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction //new()

    //==================================================================================
    virtual function void build_phase(uvm_phase phase);
        `LOGN(("build phase starts..."))
      	super.build_phase(phase);

        env = vlc_env::type_id::create("env", this);

        `LOGN(("build phase ends..."))
    endfunction
  
  	//==================================================================================
    virtual function void connect_phase(uvm_phase phase);
        `LOGN(("connect_phase starts..."))
      	super.connect_phase(phase);
        `LOGN(("connect_phase ends..."))
    endfunction

    //==================================================================================
    virtual function void start_of_simulation_phase(uvm_phase phase);
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
    virtual task reset_phase(uvm_phase phase);
        `LOGN(("reset phase starts..."))
        phase.raise_objection(this);
        super.reset_phase(phase);
        rst_seq = vlc_rst_seq::type_id::create("rst_seq");
      	assert(rst_seq.randomize() with {rst_on_percent == 0;});
        rst_seq.start(env.rst_agent.seqr);
        phase.drop_objection(this);
        `LOGN(("reset phase ends..."))
    endtask

    //==================================================================================
    virtual task main_phase(uvm_phase phase);
        `LOGN(("main phase starts..."))
        super.main_phase(phase);
      	phase.raise_objection(this);
        vseq = vlc_main_seq::type_id::create("vseq");
      assert(vseq.randomize() with {repetitions == 100;
                                      max_length  == 32; // pow(2, 15) - 1
                                      min_length  == 1;});
        vseq.start(env.main_agent.seqr);
      	phase.drop_objection(this);
        `LOGN(("main phase ends..."))
    endtask


endclass //base_test