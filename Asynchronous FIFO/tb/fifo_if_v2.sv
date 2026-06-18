interface fifo_if #(
    parameter WIDTH = 8,
    parameter ADDR  = 14
);

    //--------------------------------------------------
    // Clock & Reset
    //--------------------------------------------------
    logic wr_clk;
    logic rd_clk;
    logic rst_n;

    //--------------------------------------------------
    // Write Side Signals
    //--------------------------------------------------
    logic             wr_enable;
    logic [WIDTH-1:0] wr_data;

    //--------------------------------------------------
    // Read Side Signals
    //--------------------------------------------------
    logic             rd_enable;
    logic [WIDTH-1:0] rd_data;

    //--------------------------------------------------
    // Status Signals
    //--------------------------------------------------
    logic full;
    logic empty;

    //--------------------------------------------------
    // Write Clocking Block
    //--------------------------------------------------
    clocking wr_cb @(posedge wr_clk);

        default input #1step output #1step;

        output wr_enable;
        output wr_data;

        input  full;

    endclocking

    //--------------------------------------------------
    // Read Clocking Block
    //--------------------------------------------------
    clocking rd_cb @(posedge rd_clk);

        default input #1step output #1step;

        output rd_enable;

        input  rd_data;
        input  empty;

    endclocking

    //--------------------------------------------------
    // Write Driver Modport
    //--------------------------------------------------
    modport WR_DRV (

        clocking wr_cb,

        input wr_clk,
        input rst_n

    );

    //--------------------------------------------------
    // Read Driver Modport
    //--------------------------------------------------
    modport RD_DRV (

        clocking rd_cb,

        input rd_clk,
        input rst_n

    );

    //--------------------------------------------------
    // Write Monitor Modport
    //--------------------------------------------------
    modport WR_MON (

        input wr_clk,
        input rst_n,

        input wr_enable,
        input wr_data,

        input full

    );

    //--------------------------------------------------
    // Read Monitor Modport
    //--------------------------------------------------
    modport RD_MON (

        input rd_clk,
        input rst_n,

        input rd_enable,
        input rd_data,

        input empty

    );

    //--------------------------------------------------
    // DUT Modport
    //--------------------------------------------------
    modport DUT (

        input wr_clk,
        input rd_clk,
        input rst_n,

        input wr_enable,
        input rd_enable,

        input wr_data,

        output rd_data,

        output full,
        output empty

    );

endinterface
