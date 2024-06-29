class vlc_rst_seq extends uvm_sequence#(vlc_seq_item);

    //==================================================================================
    `uvm_object_utils(vlc_rst_seq)

    //==================================================================================
    rand int  assert_cycles;
    rand int  deassert_cycles;
    rand bit  rst_now;
    rand int  rst_on_percent;
    rand int  rst_off_percent;
    uvm_event firts_reset_done;

    //==================================================================================
    constraint rst_off_percent_c {
        rst_off_percent == 100-rst_on_percent;
    }
  
  	//==================================================================================
    constraint rst_cycles_c {
        assert_cycles   == 10;
        deassert_cycles == 1;
    }

    //==================================================================================
    function new (string name = "vlc_rst_seq");
        super.new(name);
    endfunction

    //==================================================================================
    task body();
        firts_reset_done = uvm_event_pool::get_global("firts_reset_done");
        repeat(deassert_cycles)
            `uvm_do_with(req, { rst == 1; })
        repeat(assert_cycles)
            `uvm_do_with(req, { rst == 0; })
        firts_reset_done.trigger();
        repeat(deassert_cycles)
            `uvm_do_with(req, { rst == 1 ; })
        
        fork
            forever begin
              std::randomize (rst_now) with { rst_now dist { 0:=rst_off_percent, 1:=rst_on_percent };};
                if(rst_now) begin
                    `uvm_do_with(req, { rst == 0 ; })
                    `uvm_do_with(req, { rst == 1 ; })
                end
                #(`CLOCK_PERIOD);
            end
        join_none
    endtask
    
endclass //vlc_rst_seq