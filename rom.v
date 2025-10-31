module rom_module(
    input clk,rst,load,
    input [3:0]address,
    output reg [6:0]data
);

reg [6:0]rom[0:15];

always @(posedge clk) begin
    rom[0] <= 12;
    rom[1] <= 23;
    rom[2] <= 34;
    rom[3] <= 45;
    rom[4] <= 56;
    rom[5] <= 67;
    rom[6] <= 78;
    rom[7] <= 89;
    rom[8] <= 93;
    rom[9] <= 18;
    rom[10] <= 19;
    rom[11] <= 17;
    rom[12] <= 27;
    rom[13] <= 28;
    rom[14] <= 39;
    rom[15] <= 43;
end

always @(posedge clk or posedge rst) begin
    if(rst) begin
        data <= 0;
    end
    else begin
        if(load) begin
            data <= rom[address];
        end
    end
end

endmodule