class vlc_seq_item extends uvm_sequence_item;

    //==================================================================================
    rand logic din_valid;
    rand logic data_in;
    rand logic dout_valid;
    rand logic data_out;
    rand logic rst;

    rand int stagger; // delay between each transaction
    rand int length;  // length of transactions

    //==================================================================================
    `uvm_object_utils_begin(vlc_seq_item)
        `uvm_field_int(rst, UVM_DEFAULT)
        `uvm_field_int(data_in, UVM_DEFAULT)
        `uvm_field_int(din_valid, UVM_DEFAULT)
        `uvm_field_int(data_out, UVM_DEFAULT)
        `uvm_field_int(dout_valid, UVM_DEFAULT)
        `uvm_field_int(stagger, UVM_DEFAULT, UVM_NOCOMPARE)
        `uvm_field_int(length, UVM_DEFAULT, UVM_NOCOMPARE)
    `uvm_object_utils_end

    //==================================================================================
    function new (string name = "vlc_seq_item");
        super.new(name);
    endfunction


endclass //vlc_seq_item 
