`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Hatem Ali
// 
// Create Date:    11:46:02 04/25/2022 
// Design Name:	   
// Module Name:    top_TX 
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
module top_TX(
    input clk,
    input rst,
    input data_in,
    input din_valid,
    output dout_valid,
    output data_out
    );
	 
	 wire type_of_occurrence;
	 wire count_log_dout_valid;
	 wire [`THIRD_FIELD_SIZE-1:0] count_log_data_out;
	 wire [1+(`SEC_FIELD_SIZE+`THIRD_FIELD_SIZE-1):0] log_serial_data_out;
	 wire log_serial_dout_valid;
	 
	 vlc_count count_block(clk, rst, data_in, din_valid, type_of_occurrence, count_log_dout_valid, count_log_data_out);
	 log log_block(clk, rst, type_of_occurrence, count_log_dout_valid, count_log_data_out, log_serial_data_out, log_serial_dout_valid);
	 serializer serial_block(clk, rst, log_serial_dout_valid, log_serial_data_out, data_out, dout_valid);
	
endmodule
