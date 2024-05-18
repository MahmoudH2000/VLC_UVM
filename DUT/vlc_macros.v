//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Hatem Ali
// 
// Create Date:    10:03:30 03/04/2022 
// Design Name:    Hatem Ali
// Module Name:    vlc_macros 
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

// Macros used in the VLC design are defined here

// SEC_FIELD_SIZE: size of second field of variable length code
`define SEC_FIELD_SIZE 4

// THIRD_FIELD_SIZE: size of third field of variable length code
`define THIRD_FIELD_SIZE (2**`SEC_FIELD_SIZE)-1

// Testbench Clock to Q output delay (simulator safety)
`define TP 0.1
