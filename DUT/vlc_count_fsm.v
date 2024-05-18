`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:  Hatem Ali
// 
// Create Date:    09:57:12 03/04/2022 
// Design Name:	   
// Module Name:    vlc_count 
// Project Name:   
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
/////////////////////////////////////////////////////////////////////////////////
`include "vlc_macros.v";
module vlc_count(
    input clk,
    input rst,
    input data_in,
    input din_valid,
    output type_of_occurrence,
    output dout_valid,
    output [`THIRD_FIELD_SIZE-1:0] data_out
    );
	
	parameter TP = `TP ;
	
   // register for input data
	reg r_data_in;
	reg r_din_valid;
	
	// registers for output
	reg r_type_of_occurrence;
	reg r_dout_valid;
	reg [`THIRD_FIELD_SIZE-1:0] r_data_out;
	
	// Internal wires & flags
	wire previous_type;
    wire previous_din_valid;
	reg  toggle_type_of_occurrence;
	reg  [`THIRD_FIELD_SIZE-1:0] zero_counter;
	reg  [`THIRD_FIELD_SIZE-1:0] one_counter;
	
	
	always @(posedge clk or negedge rst) begin
		if(!rst) begin			
			one_counter                 <= #TP 0;
			zero_counter                <= #TP 0;
			r_data_in                   <= #TP 1'b0;
			r_din_valid                 <= #TP 1'b0;
		end
		else begin
			r_data_in                   <= #TP data_in;
			r_din_valid                 <= #TP din_valid;
			if(din_valid) begin
				if(data_in) begin
					one_counter  <= #TP one_counter + 1;
					zero_counter <= #TP 0;
				end
				else begin
					zero_counter <= #TP zero_counter + 1;
					one_counter  <= #TP 0;
				end
			end
		end
	end
	
    always @(*) begin
	    toggle_type_of_occurrence = 1'b0 ;
	    if (data_in != previous_type || (din_valid == 1'b0 && previous_din_valid == 1'b1)) begin
		    toggle_type_of_occurrence = 1'b1 ;
	    end
	end


	always @(*) begin		
		r_type_of_occurrence = 1'b0;
		r_dout_valid         = 1'b0;
		r_data_out           = 0;
		if(toggle_type_of_occurrence) begin
			r_type_of_occurrence = previous_type;
			r_dout_valid         = 1'b1;
			if(previous_type)
				r_data_out = one_counter;
			else
				r_data_out = zero_counter;
		end
	end
	
	assign type_of_occurrence = r_type_of_occurrence;
	assign dout_valid         = r_dout_valid;
	assign data_out           = r_data_out;
	assign previous_type      = r_data_in;
	assign previous_din_valid = r_din_valid;
endmodule