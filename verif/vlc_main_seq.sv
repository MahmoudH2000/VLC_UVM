class vlc_main_seq extends uvm_sequence#(vlc_seq_item);

    //==================================================================================
    `uvm_opject_utils(vlc_main_seq)

    //==================================================================================
    rand int repetitions;
    rand int max_length; // = 32767; // pow(2, 15) - 1
    rand int min_length; // = 1;


    //==================================================================================
    function new (string name = "vlc_main_seq");
        super.new(name);
    endfunction

    //==================================================================================
    task body();
        repeat(repetitions) begin
            `uvm_do_with(req, {length  inside [min_length:max_length];
                               stagger inside [0:15]; })
        end
    endtask

endclass //vlc_main_seq
