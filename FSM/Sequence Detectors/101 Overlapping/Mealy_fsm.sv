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

    // S0 --x=0/y=0--> S0
    // S0 --x=1/y=0--> S1

    // S1 --x=0/y=0--> S2
    // S1 --x=1/y=0--> S1

    // S2 --x=0/y=0--> S0
    // S2 --x=1/y=1--> S1

    typedef enum logic [1:0] {
        S0 = 2'b00,
        S1 = 2'b01,
        S2 = 2'b10  
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

    //next state and output logic
    always_comb begin
        next_state = state; // default to hold state
        y = 1'b0; // default output
        case (state)
            S0: begin
                if (x) begin
                    next_state = S1;
                end
                else begin
                    next_state = S0;
                end
            end
            S1: begin
                if (x) begin
                    next_state = S1;
                end
                else begin
                    next_state = S2;
                end
            end
            S2: begin
                if (x) begin
                    next_state = S1;
                    y = 1'b1; // output '1' when sequence '101' is detected
                end
                else begin
                    next_state = S0;
                end
            end
            default: begin
                next_state = S0;
                y = 1'b0;
            end
        endcase
    end

endmodule
