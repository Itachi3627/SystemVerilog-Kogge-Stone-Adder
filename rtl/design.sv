module kogge_stone_adder #(
    parameter WIDTH = 16
) (
    input  logic [WIDTH-1:0] A,
    input  logic [WIDTH-1:0] B,
    input  logic             cin,
    output logic [WIDTH-1:0] sum,
    output logic             cout
);

    localparam int STAGES = $clog2(WIDTH);
    
    // P (propagate) and G (generate) signals for each s
    logic [WIDTH-1:0] P [0:STAGES];
    logic [WIDTH-1:0] G [0:STAGES];
    
    // s 0: Initialize with input propagate and generate
    always_comb begin
        for (int i = 0; i < WIDTH; i++) begin
            P[0][i] = A[i] ^ B[i];  // Propagate: XOR
            if (i == 0) begin
                // Incorporate carry-in at bit 0
                G[0][i] = A[i] & B[i] | (cin & (A[i] ^ B[i]));
            end else begin
                G[0][i] = A[i] & B[i];  // Generate: AND
            end
        end
    end
    
    // Generate STAGES for Kogge-Stone tree
    genvar s, i;
    generate
        for (s = 1; s <= STAGES; s++) begin : gen_STAGES
            localparam int DISTANCE = 1 << (s - 1);
            
            for (i = 0; i < WIDTH; i++) begin : gen_bits
                always_comb begin
                    if (i >= DISTANCE) begin
                        // Combine with previous s at DISTANCE away
                        P[s][i] = P[s-1][i] & P[s-1][i - DISTANCE];
                        G[s][i] = G[s-1][i] | (P[s-1][i] & G[s-1][i - DISTANCE]);
                    end else begin
                        // pass through unchanged
                        P[s][i] = P[s-1][i];
                        G[s][i] = G[s-1][i];
                    end
                end
            end
        end
    endgenerate
    
    // Compute final sum and carry out
    always_comb begin
        for (int i = 0; i < WIDTH; i++) begin
            if (i == 0) begin
                // Bit 0: carry-in is cin
                sum[i] = P[0][i] ^ cin;
            end else begin
                // Bit i: carry-in is the generated carry from i-1
                sum[i] = P[0][i] ^ G[STAGES][i-1];
            end
        end
        
        // Final carry out from the MSB
        cout = G[STAGES][WIDTH-1];
    end

endmodule 