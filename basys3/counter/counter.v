module counter(
    input clk,
    output reg [6:0]count
);

always @(posedge clk)
begin
    if(count != 59) begin
        count <= count + 1;
    end
    else begin
        count <= 0;
    end 
end

endmodule