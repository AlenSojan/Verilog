module seq(
    input x,
    input rst_n,
    input clk,
    output reg y
);

    // state diagram of 101 detector

    // S0 : No match yet
    // S1 : Detected '1'
    // S2 : Detected '10'
    // S3 : Detected '101' (output '1')

    // S0 --x=0--> S0
    // S0 --x=1--> S1

    // S1 --x=0--> S2
    // S1 --x=1--> S1

    // S2 --x=0--> S0
    // S2 --x=1--> S3

    // S3 --x=0--> S2
    // S3 --x=1--> S1

    typedef enum logic [1:0] {
        S0 = 2'b00,
        S1 = 2'b01,
        S2 = 2'b10,
        S3 = 2'b11
    } state_t;

    state_t state, next_state;

    //state register
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S0;
        end
        else begin
            state <= next_state;
        end
    end

    //next state logic
    always_comb begin
        case (state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S1 : S2;
            S2: next_state = x ? S3 : S0;
            S3: next_state = x ? S1 : S2;
            default: next_state = S0;
        endcase
    end

    //output logic
    always_comb begin
        if (state == S3) begin
            y = 1'b1;
        end
        else begin
            y = 1'b0;
        end
    end

endmodule
