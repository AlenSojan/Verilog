module displayer(
    input clk,
    input [6:0]msb,lsb,
    output reg [3:0]anode,
    output reg [6:0]seg
);

reg [16:0]count;
localparam max=10_000; 

reg disp;

always@(posedge clk) begin
    if(count == max) begin
        count <= 0;
        disp <= ~disp;
    end
    else begin
        count <= count + 1;
    end
end

always@(posedge clk) begin
    if(disp) begin
        anode <= 4'b1101;
        seg <= msb;
    end
    else begin
        anode <= 4'b1110;
        seg <= lsb;
    end
end

endmodule