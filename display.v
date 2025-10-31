module display(
    input clk,
    input [3:0]Td,Ud,
    output reg [6:0]seg,
    output reg [3:0]anode
);

    reg [6:0]Td_seg,Ud_seg;
    reg [18:0]count;
    reg sel;

    parameter max = 10_000;

    always @(posedge clk) begin
        if(max == count) begin
            count <= 0;
            sel <= sel + 1;
        end
        else begin
            count <= count + 1;
        end
    end

    always @(posedge clk) begin
        case (sel)
            0 : begin
                anode <= 4'b1110;
                seg <= Ud_seg;
                end

            1 : begin
                anode <= 4'b1101;
                seg <= Td_seg;
                end
        endcase
    end

    always @(posedge clk) begin
        case(Td)
            4'b0000 : Td_seg = 7'b1000000;
            4'b0001 : Td_seg = 7'b1111001;   
            4'b0010 : Td_seg = 7'b0100100;   
            4'b0011 : Td_seg = 7'b0110000;   
            4'b0100 : Td_seg = 7'b0011001;   
            4'b0101 : Td_seg = 7'b0010010;   
            4'b0110 : Td_seg = 7'b0000010;   
            4'b0111 : Td_seg = 7'b1111000;   
            4'b1000 : Td_seg = 7'b0000000;   
            4'b1001 : Td_seg = 7'b0010000;
            default : Td_seg = 7'b1000000; 
        endcase
    end

    always @(posedge clk) begin
        case(Ud)
            4'b0000 : Ud_seg = 7'b1000000;
            4'b0001 : Ud_seg = 7'b1111001;   
            4'b0010 : Ud_seg = 7'b0100100;   
            4'b0011 : Ud_seg = 7'b0110000;   
            4'b0100 : Ud_seg = 7'b0011001;   
            4'b0101 : Ud_seg = 7'b0010010;   
            4'b0110 : Ud_seg = 7'b0000010;   
            4'b0111 : Ud_seg = 7'b1111000;   
            4'b1000 : Ud_seg = 7'b0000000;   
            4'b1001 : Ud_seg = 7'b0010000;
            default : Ud_seg = 7'b1000000; 
        endcase
    end

endmodule