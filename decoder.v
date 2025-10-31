module decoder(
    input clk,
    input [6:0]data,
    output reg [3:0]Td,Ud 
);

always @(posedge clk)
begin
    Td <= data / 10;
    Ud <= data % 10;
end

endmodule