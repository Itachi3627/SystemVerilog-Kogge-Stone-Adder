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
    
    logic [WIDTH-1:0] P [0:STAGES];
    logic [WIDTH-1:0] G [0:STAGES];
    
    always_comb begin
        for (int i = 0; i < WIDTH; i++) begin
            P[0][i] = A[i] ^ B[i];  
            if (i == 0) begin
                
                G[0][i] = A[i] & B[i] | (cin & (A[i] ^ B[i]));
            end else begin
                G[0][i] = A[i] & B[i];  
            end
        end
    end
    
    genvar s, i;
    generate
        for (s = 1; s <= STAGES; s++) begin : gen_STAGES
            localparam int DISTANCE = 1 << (s - 1);
            
            for (i = 0; i < WIDTH; i++) begin : gen_bits
                always_comb begin
                    if (i >= DISTANCE) begin
                        P[s][i] = P[s-1][i] & P[s-1][i - DISTANCE];
                        G[s][i] = G[s-1][i] | (P[s-1][i] & G[s-1][i - DISTANCE]);
                    end else begin
                        P[s][i] = P[s-1][i];
                        G[s][i] = G[s-1][i];
                    end
                end
            end
        end
    endgenerate
    
    always_comb begin
        for (int i = 0; i < WIDTH; i++) begin
            if (i == 0) begin
                sum[i] = P[0][i] ^ cin;
            end else begin
                sum[i] = P[0][i] ^ G[STAGES][i-1];
            end
        end
        
        cout = G[STAGES][WIDTH-1];
    end

endmodule 