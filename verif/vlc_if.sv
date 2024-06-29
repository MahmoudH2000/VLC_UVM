interface vlc_if(
    input clk
);

    logic rst;

    logic data_in;
    logic din_valid;
    logic data_out;
    logic dout_valid;

    // data clocking
    clocking cb_drv @(posedge clk);
        default output #1step;
        output data_in;
        output din_valid;
    endclocking

    clocking cb_mon @(posedge clk);
      	input data_in;
        input din_valid;
        input data_out;
        input dout_valid;
    endclocking

    // rst clocking
    clocking cb_rst_drv @(posedge clk);
        default output #1step;
        output rst;
    endclocking

    clocking cb_rst_mon @(posedge clk);
        input rst;
    endclocking
endinterface //vlc_if

