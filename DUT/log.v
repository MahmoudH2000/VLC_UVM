`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Hatem Ali
// 
// Create Date:    11:19:42 04/08/2022 
// Design Name:	   
// Module Name:    log 
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
//////////////////////////////////////////////////////////////////////////////////
`include "vlc_macros.v";
module log(clk, rst, type_of_occurrence, din_valid, data_in, data_out, dout_valid);
	input clk;
	input rst;
	input type_of_occurrence;
	input din_valid;
	input  [`THIRD_FIELD_SIZE-1:0] data_in;
	output [1+(`SEC_FIELD_SIZE+`THIRD_FIELD_SIZE-1):0] data_out;
	output dout_valid;
	
	parameter TP = `TP ;
	
	wire [`THIRD_FIELD_SIZE-1:0] data_in;
	reg  [`SEC_FIELD_SIZE-1:0]  n_var;
	
	always @(*) begin
		n_var = 0;
		if(din_valid) begin
			n_var = clog2(data_in);
		end
	end
   assign data_out = {type_of_occurrence, n_var, data_in};
	assign dout_valid = din_valid;
	
	function [`THIRD_FIELD_SIZE-1:0] clog2;
		input [`THIRD_FIELD_SIZE-1:0] value;
		integer i;
		reg done;
		begin
		   done = 0;
			clog2 = 0;
			for (i=`THIRD_FIELD_SIZE; i>=1; i=i-1) begin			
				if(value[i-1] == 1 && !done) begin
					done = 1;
					clog2 = i;				
				end
			end
		end
	endfunction

endmodule
