`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:  Hatem Ali
// 
// Create Date:    12:02:35 04/23/2022 
// Design Name:	   
// Module Name:    serializer 
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
module serializer(clk, rst, din_valid, d_in, d_out, dout_valid);
	parameter COUNTER_INIT_VAL = `SEC_FIELD_SIZE+`THIRD_FIELD_SIZE;
	parameter TP               = `TP;
	input                                              clk;
	input                                              rst;
	input                                              din_valid;
	input  [1+(`SEC_FIELD_SIZE+`THIRD_FIELD_SIZE-1):0] d_in;
	output reg                                         d_out;
	output reg                                         dout_valid;

	reg [`THIRD_FIELD_SIZE-1:0]                     counter;
	reg [`SEC_FIELD_SIZE-1:0]                       num_of_bits;
	reg [1+(`SEC_FIELD_SIZE+`THIRD_FIELD_SIZE-1):0] int_ram[0:31];
	reg [1+(`SEC_FIELD_SIZE+`THIRD_FIELD_SIZE-1):0] r_input;
	reg [5:0]                                       ram_wr_add;
	reg [5:0]                                       ram_rd_add;
	reg                                             in_progress;
	reg                                             overflow_flag;
	reg                                             underflow_flag;
    
	integer i;
	// Write block
	always @(posedge clk , negedge rst) begin
		if(!rst) begin
			for(i=0; i<32; i=i+1) begin
				int_ram[i] = 0;
			end
			ram_wr_add    = 0;
			overflow_flag = 0;			
        end
		else begin
			if(din_valid && !overflow_flag) begin
				int_ram[ram_wr_add[4:0]] = d_in;
				ram_wr_add               = ram_wr_add + 1;				
			end
			// overflow flag
			if({~ram_wr_add[5], ram_wr_add[4:0]} == ram_rd_add)
				overflow_flag = 1;
			else
				overflow_flag = 0;
		end
	end
	
	// read block
	always @(posedge clk , negedge rst) begin
		if(!rst) begin
			r_input        = 0;
			ram_rd_add     = 0;
			underflow_flag = 1;
			in_progress    = 0;
        end
		else begin
			if(!in_progress && !underflow_flag) begin
				r_input             = int_ram[ram_rd_add[4:0]];
				num_of_bits         = r_input[`SEC_FIELD_SIZE+`THIRD_FIELD_SIZE-1:`THIRD_FIELD_SIZE];
				counter             = COUNTER_INIT_VAL;
				dout_valid          = 0;
				ram_rd_add          = ram_rd_add + 1;
				in_progress         = 1;
			end
			// underflow flag
			if(ram_wr_add == ram_rd_add)
				underflow_flag = 1;
			else
				underflow_flag = 0;
		end
	end
	
	// Serializing block
	always @(posedge clk , negedge rst) begin
        if(!rst) begin			
			ram_rd_add  = 0;
			num_of_bits = 0;
			counter     = 0;
			d_out       = 0;
			dout_valid  = 0;
        end
        else begin
			if(in_progress) begin
				if(counter < `THIRD_FIELD_SIZE) begin
					if(counter > num_of_bits - 1) begin
						counter    = num_of_bits - 2;
						d_out      = r_input[num_of_bits - 1];
						dout_valid = 1;
						if(counter[`THIRD_FIELD_SIZE-1] == 1)
							in_progress = 0;
					end
					else begin
						d_out      = r_input[counter];
						dout_valid = 1;
						if(counter == 0)
							in_progress = 0;
						counter    = counter - 1;
					end
				end
				else begin
					if(counter <= `SEC_FIELD_SIZE+`THIRD_FIELD_SIZE) begin
						d_out      = r_input[counter];
						dout_valid = 1;
						counter    = counter - 1;
					end
					else begin
						d_out      = 0;
						dout_valid = 0;
						counter    = counter;
					end
				end
			end
			else begin
				d_out      = 0;
				dout_valid = 0;
			end
        end
    end
endmodule
