module async_fifo #(
    parameter WIDTH = 8,
    parameter ADDR  = 14
)(
    input                   wr_clk,
    input                   rd_clk,
    input                   rst_n,

    input                   wr_enable,
    input                   rd_enable,

    input  [WIDTH-1:0]      wr_data,

    output reg              full,
    output reg              empty,
    output reg [WIDTH-1:0]  rd_data
);

    //--------------------------------------------------
    // Memory
    //--------------------------------------------------
    reg [WIDTH-1:0] fifo [(1<<ADDR)-1:0];

    //--------------------------------------------------
    // Binary and Gray pointers
    //--------------------------------------------------
    reg [ADDR:0] wr_bin, wr_gray;
    reg [ADDR:0] rd_bin, rd_gray;

    //--------------------------------------------------
    // Gray pointer synchronizers
    //--------------------------------------------------
    reg [ADDR:0] rd_gray_sync1, rd_gray_sync2;
    reg [ADDR:0] wr_gray_sync1, wr_gray_sync2;

    //--------------------------------------------------
    // Binary -> Gray conversion
    //--------------------------------------------------
    function [ADDR:0] bin2gray;
        input [ADDR:0] bin;
        begin
            bin2gray = bin ^ (bin >> 1);
        end
    endfunction

    //--------------------------------------------------
    // Synchronize read pointer into write domain
    //--------------------------------------------------
    always @(posedge wr_clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_gray_sync1 <= 0;
            rd_gray_sync2 <= 0;
        end
        else begin
            rd_gray_sync1 <= rd_gray;
            rd_gray_sync2 <= rd_gray_sync1;
        end
    end

    //--------------------------------------------------
    // Synchronize write pointer into read domain
    //--------------------------------------------------
    always @(posedge rd_clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_gray_sync1 <= 0;
            wr_gray_sync2 <= 0;
        end
        else begin
            wr_gray_sync1 <= wr_gray;
            wr_gray_sync2 <= wr_gray_sync1;
        end
    end

    //--------------------------------------------------
    // Write side
    //--------------------------------------------------
    wire wr_inc;

    assign wr_inc = wr_enable && !full;

    wire [ADDR:0] wr_bin_next;
    wire [ADDR:0] wr_gray_next;

    assign wr_bin_next  = wr_bin + wr_inc;
    assign wr_gray_next = bin2gray(wr_bin_next);

    always @(posedge wr_clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_bin  <= 0;
            wr_gray <= 0;
        end
        else begin
            if (wr_inc)
                fifo[wr_bin[ADDR-1:0]] <= wr_data;

            wr_bin  <= wr_bin_next;
            wr_gray <= wr_gray_next;
        end
    end

    //--------------------------------------------------
    // Read side
    //--------------------------------------------------
    wire rd_inc;

    assign rd_inc = rd_enable && !empty;

    wire [ADDR:0] rd_bin_next;
    wire [ADDR:0] rd_gray_next;

    assign rd_bin_next  = rd_bin + rd_inc;
    assign rd_gray_next = bin2gray(rd_bin_next);

    always @(posedge rd_clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_bin  <= 0;
            rd_gray <= 0;
            rd_data <= 0;
        end
        else begin
            if (rd_inc)
                rd_data <= fifo[rd_bin[ADDR-1:0]];

            rd_bin  <= rd_bin_next;
            rd_gray <= rd_gray_next;
        end
    end

    //--------------------------------------------------
    // FULL generation (write domain)
    //
    // FIFO full when next write pointer equals
    // synchronized read pointer with upper
    // two bits inverted.
    //--------------------------------------------------
    wire full_next;

    assign full_next =
        (wr_gray_next ==
        {~rd_gray_sync2[ADDR:ADDR-1],
          rd_gray_sync2[ADDR-2:0]});

    always @(posedge wr_clk or negedge rst_n) begin
        if (!rst_n)
            full <= 1'b0;
        else
            full <= full_next;
    end

    //--------------------------------------------------
    // EMPTY generation (read domain)
    //--------------------------------------------------
    wire empty_next;

    assign empty_next =
        (rd_gray_next == wr_gray_sync2);

    always @(posedge rd_clk or negedge rst_n) begin
        if (!rst_n)
            empty <= 1'b1;
        else
            empty <= empty_next;
    end

endmodule