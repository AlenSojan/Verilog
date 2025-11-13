module clock_gen(
    input clk,
    output reg clk_out
);

reg [26:0] count;
localparam max =100_000_000;

always @(posedge clk) begin
    if(count == max) begin
        count <= 0;
        clk_out <= ~clk_out;
    end
    else begin
        count <= count + 1;
    end
end
    
endmodule
