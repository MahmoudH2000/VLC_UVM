`uvm_analysis_imp_decl(_rst)
`uvm_analysis_imp_decl(_main)

class vlc_sb extends uvm_scoreboard;

    //==================================================================================
    `uvm_component_utils(vlc_sb)

    
    //==================================================================================
    uvm_analysis_imp_rst#(vlc_seq_item, vlc_sb) rst_analysis_export;
    uvm_analysis_imp_main_in#(vlc_seq_item, vlc_sb) main_in_analysis_export;
    uvm_analysis_imp_main_out#(vlc_seq_item, vlc_sb) main_out_analysis_export;

    //==================================================================================
    bit check_en = 1;
    consecutive_data input_data;
    vlc_data vlc_data;
    input_state input_curr_state;
    output_state output_curr_state;
    consecutive_data input_q[$];
    consecutive_data output_q[$];

    bit[4-1:0] length_counter = 4'd3;
    bit[4-1:0] bits_left_counter; // curr number of bits in the third field

    //==================================================================================
    function new(string name="vlc_sb", uvm_component parent=null);
        super.new(name, parent);
    endfunction //new()

    //==================================================================================
    virtual task build_phase(uvm_phase phase);
        `LOGD(("entered build phase"))
        super.build_phase(phase)
        
        // create analysis imports
        rst_analysis_export      = new("rst_analysis_export", this);
        main_in_analysis_export  = new("main_in_analysis_export", this);
        main_out_analysis_export = new("main_out_analysis_export", this);
        
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

    //==================================================================================
    virtual task main_phase(uvm_phase phase);
        `LOGD(("main_phase starts..."))
        super.main_phase(phase)

        fork
            check_output();
        join_none

        `LOGD(("main_phase ends..."))
    endtask

    virtual task check_output();
        consecutive_data in;
        consecutive_data out;
        forever begin
            wait(output_q.size() != 0);
            in = input_q.pop_front();
            out = output_q.pop_front();
            if (out.my_type != in.my_type && check_en) begin
                `LOGE("error in type. type is 'b%0b and it should be 'b%0b", out.my_type, in.my_type)
            end
            if (out.length != in.length && check_en) begin
                `LOGE("error in length. length is 'h%0h and it should be 'h%0h", out.length, in.length)
            end
        end
    endtask

    //==================================================================================
    function void write_main(vlc_seq_item txn);
        collect_input(txn.din_valid, txn.data_in);
        collect_input(txn.dout_valid, txn.data_out);
    endfunction

    //==================================================================================
    function void collect_input(bit din_valid, bit data_in);
        case (input_curr_state)
            IDLE: begin
                if (din_valid) begin
                    input_data.length  = 1;
                    if (data_in) begin
                        input_curr_state = ONE;
                        input_data.my_type = 1;
                    end
                    else begin
                        input_curr_state = ZERO;
                        input_data.my_type = 0;
                    end
                end
            end
            ONE: begin
                if (!din_valid) begin
                    input_q.push_back(input_data);
                    input_curr_state = IDLE;
                end
                else begin
                    if (data_in) begin
                        input_data.length++;
                    end
                    else begin
                        input_q.push_back(input_data);

                        input_curr_state = ZERO;
                        input_data.length = 1;
                        input_data.my_type = 0;
                    end
                end
            end
            ZERO: begin
                if (!din_valid) begin
                    input_q.push_back(input_data);
                    input_curr_state = IDLE;
                end
                else begin
                    if (!data_in) begin
                        input_data.length++;
                    end
                    else begin
                        input_q.push_back(input_data);

                        input_curr_state = ONE;
                        input_data.length = 1;
                        input_data.my_type = 1;
                    end
                end
            end
        endcase
    endfunction

    //==================================================================================
    function void collect_ouput(bit dout_valid, bit data_out);
        case (output_curr_state)
            IDLE: begin
                if (dout_valid) begin
                    vlc_data.my_type = data_out;
                    output_curr_state = LENGTH;
                end
            end
            LENGTH: begin
                if(!dout_valid && check_en) 
                    `LOGE(("output format Error second field is not 4 bits is not 4 bits"))
                
                vlc_data.length[length_counter] = data_out;
                if (length_counter == 0) begin
                    length_counter = 3;
                    output_curr_state = STREAM_LENGTH;
                    bits_left_counter = vlc_data.length-1;
                end
                else 
                    length_counter--;
            end
            STREAM_LENGTH: begin
                if(!dout_valid && check_en) 
                    `LOGE(("output format Error third field's length incorrect"))
                
                vlc_data.stream_length[bits_left_counter] = data_out;
                if (bits_left_counter == 0) begin
                    output_q.push_back(transform_vlc_data(vlc_data));
                    if (dout_valid) begin
                        vlc_data.my_type  = data_out;
                        output_curr_state = LENGTH;
                    end
                    else begin
                        output_curr_state = IDLE;
                    end
                end
                else 
                    bits_left_counter--;
            end
        endcase
    endfunction

    //==================================================================================
    function consecutive_data transform_vlc_data(vlc_data vlc_data);
        consecutive_data data;
        data.my_type = vlc_data.my_type;
        data.length = vlc_data.stream_length;
        return data;
    endfunction
endclass //vlc_sb