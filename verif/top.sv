import uvm_pkg::*;
`include "vlc_if.sv"

module top ();

// parameters
`define CLOCK_PERIOD = 10;

// DUT signals
logic clk;
logic rst;
logic data_in;
logic din_valid;
logic data_out;
logic dout_valid;

// DUT instantiation
top_TX DUT(
    .clk(clk),
    .rst(rst),
    .data_in(data_in),
    .din_valid(din_valid),
    .dout_valid(dout_valid),
    .data_out(data_out)
);

// interface connections
vlc_if vlc_if(.clk(clk));
assign rst               = vlc_if.rst;
assign data_in           = vlc_if.data_in;
assign din_valid         = vlc_if.din_valid;
assign vlc_if.data_out   = data_out;
assign vlc_if.dout_valid = dout_valid;

// clk gen
initial begin
    clk = 1'b0;
    forever begin
        #(CLOCK_PERIOD/2);
        clk = ~clk;
    end
end

// run test
initial begin
    // ASK check if correct (also is really necessary to have a rst agent)
    uvm_config_db#(virtual vlc_if)::set(null, "uvm_test_top.env.main_agent", "vif", vlc_if);
    uvm_config_db#(virtual vlc_if)::set(null, "uvm_test_top.env.rst_agent", "vif", vlc_if);
    run_test();
end

// dump waves
initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
end
    
endmodule