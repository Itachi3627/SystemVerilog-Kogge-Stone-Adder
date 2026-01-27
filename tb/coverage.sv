class coverage;
  mailbox #(transaction) mon2cov;
    transaction trans;

     covergroup cg_kogge_stone_adder;
        option.per_instance = 1;
        option.comment ="Kogge_stone_Adder Functional Coverage";

        cp_A: coverpoint trans.A {
            bins min = {16'h0000};
            bins low = {[16'h0001:16'h5555]};
            bins mid = {[16'h5556:16'hAAAA]};
            bins high = {[16'hAAAB:16'hFFFE]};
            bins max = {16'hFFFF};
        }

        cp_B: coverpoint trans.B {
            bins min = {16'h0000};
            bins low = {[16'h0001:16'h5555]};
            bins mid = {[16'h5556:16'hAAAA]};
            bins high = {[16'hAAAB:16'hFFFE]};
            bins max = {16'hFFFF};
        }
        cp_cin: coverpoint trans.cin {
            bins ci = {1'b1}; 
        }

        cp_sum: coverpoint trans.sum {
            bins min = {16'h0000};
            bins low = {[16'h0001:16'h5555]};
            bins mid = {[16'h5556:16'hAAAA]};
            bins high = {[16'hAAAB:16'hFFFE]};
            bins max = {16'hFFFF};
        }

        cp_cout: coverpoint trans.cout {
            bins taken = {1'b1}; 
        }
        
        cross_A_B_cin: cross cp_A,cp_B,cp_cin;
    endgroup


    function new(mailbox #(transaction) m2c);
        this.mon2cov = m2c;
        cg_kogge_stone_adder = new(); 
    endfunction

   task run();
      $display("[COVERAGE] Starting coverage sampling");
        forever begin
            mon2cov.get(trans);      // Get transaction from Monitor
            cg_kogge_stone_adder.sample();  // Sample the covergroup
            
            // Optional: Print current coverage % to console for debugging
            $display("[COVERAGE] Current Coverage: %.2f%%", cg_kogge_stone_adder.get_inst_coverage());
        end
    endtask
endclass