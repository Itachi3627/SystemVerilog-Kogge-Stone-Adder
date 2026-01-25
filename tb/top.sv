`include "interface.sv"
`include "environment.sv"

module tb;

    intf intff();
    environment env;

    kogge_stone_adder dut(
        .A(intff.A),
        .B(intff.B),
        .cin(intff.cin),
        .sum(intff.sum),
        .cout(intff.cout)
    );

    initial begin
    $display("===========================================");
    $display("Starting Kogge Stone Adder Testbench");
    $display("===========================================");
    
      env = new(intff, 20); // Create environment with 20 transactions
    env.run();
    
    $display("===========================================");
    $display("Testbench Complete");
    $display("===========================================");
    $finish;
  end
  

endmodule