class vlc_main_seq extends uvm_sequence#(vlc_seq_item);
  
    //==================================================================================
    rand int repetitions;
    rand int max_length; // = 32767; // pow(2, 15) - 1
    rand int min_length; // = 1;
  
  	//==================================================================================
  	`uvm_object_utils_begin(vlc_main_seq)
        `uvm_field_int(repetitions, UVM_DEFAULT)
        `uvm_field_int(max_length, UVM_DEFAULT)
        `uvm_field_int(min_length, UVM_DEFAULT)
    `uvm_object_utils_end


    //==================================================================================
    function new (string name = "vlc_main_seq");
        super.new(name);
    endfunction

    //==================================================================================
    task body();
        repeat(repetitions) begin
            `uvm_do_with(req, {length  inside {[min_length:max_length]};
                               stagger inside {[0:15]};})
        end
    endtask

endclass //vlc_main_seq
