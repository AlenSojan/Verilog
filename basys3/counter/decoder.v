module decoder(
    input clk,
    input [6:0]count,
    output reg [6:0]msb,lsb
);

reg [3:0]msb_int,lsb_int;

always @(posedge clk)
begin
    msb_int <= count / 10;
    lsb_int <= count % 10;
end

always @(posedge clk) begin
    case(msb_int)
          4'b0000 : msb = 7'b1000000;
          4'b0001 : msb = 7'b1111001;   // 1
          4'b0010 : msb = 7'b0100100;   // 2
          4'b0011 : msb = 7'b0110000;   // 3
          4'b0100 : msb = 7'b0011001;   // 4
          4'b0101 : msb = 7'b0010010;   // 5
          4'b0110 : msb = 7'b0000010;   // 6
          4'b0111 : msb = 7'b1111000;   // 7
          4'b1000 : msb = 7'b0000000;   // 8
          4'b1001 : msb = 7'b0010000;   // 9
          default : msb = 7'b1000000;
    endcase
end

always @(posedge clk) begin
    case(lsb_int)
          4'b0000 : lsb = 7'b1000000;
          4'b0001 : lsb = 7'b1111001;   // 1
          4'b0010 : lsb = 7'b0100100;   // 2
          4'b0011 : lsb = 7'b0110000;   // 3
          4'b0100 : lsb = 7'b0011001;   // 4
          4'b0101 : lsb = 7'b0010010;   // 5
          4'b0110 : lsb = 7'b0000010;   // 6
          4'b0111 : lsb = 7'b1111000;   // 7
          4'b1000 : lsb = 7'b0000000;   // 8
          4'b1001 : lsb = 7'b0010000;   // 9
          default : lsb = 7'b1000000;
    endcase
end

endmodule