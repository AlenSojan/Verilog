interface fifo_if #(parameter WIDTH = 8);

    //--------------------------------------------------
    // Clocks & Reset
    //--------------------------------------------------
    logic wr_clk;
    logic rd_clk;
    logic rst_n;

    //--------------------------------------------------
    // Write Side
    //--------------------------------------------------
    logic             wr_enable;
    logic [WIDTH-1:0] wr_data;

    //--------------------------------------------------
    // Read Side
    //--------------------------------------------------
    logic             rd_enable;
    logic [WIDTH-1:0] rd_data;

    //--------------------------------------------------
    // Status
    //--------------------------------------------------
    logic full;
    logic empty;

    //--------------------------------------------------
    // Driver Modport
    //--------------------------------------------------
    modport DRIVER (
        input  wr_clk,
        input  rd_clk,
        input  rst_n,
        input  full,
        input  empty,
        input  rd_data,

        output wr_enable,
        output rd_enable,
        output wr_data
    );

    //--------------------------------------------------
    // Monitor Modport
    //--------------------------------------------------
    modport MONITOR (
        input wr_clk,
        input rd_clk,
        input rst_n,

        input wr_enable,
        input rd_enable,

        input wr_data,
        input rd_data,

        input full,
        input empty
    );

    //--------------------------------------------------
    // DUT Modport
    //--------------------------------------------------
    modport DUT (
        input  wr_clk,
        input  rd_clk,
        input  rst_n,

        input  wr_enable,
        input  rd_enable,

        input  wr_data,

        output rd_data,

        output full,
        output empty
    );

endinterface
