class scoreboard;
    transaction trans;
    mailbox #(transaction) mon2scb;
    int passed = 0;
    int failed = 0;

    function new(mailbox #(transaction) m2s);
        this.mon2scb = m2s;
    endfunction

    task run();
      logic [16:0] expected;
        
        forever begin
         	mon2scb.get(trans); 
         	expected = 0;
            
          
          expected= trans.A + trans.B + trans.cin;

          if(({trans.cout,trans.sum}==expected)) begin
              $display("[SCOREBOARDS] PASSED, A=%h, B=%h, Cin=%h, Sum=%h, Cout=%h", trans.A, trans.B, trans.cin, trans.sum, trans.cout);  
                passed++;
            end else begin
              $display("[SCOREBOARD] FAIL: A=%h, B=%h, Cin=%h, Sum=%h, Cout=%h, expected=%h", trans.A, trans.B, trans.cin, trans.sum, trans.cout, expected);
                failed++;
            end
            
        end
    endtask

    function void report();
    $display("===========================================");
    $display("[SCOREBOARD] Test Results:");
    $display("  PASSED: %0d", passed);
    $display("  FAILED: %0d", failed);
    $display("  TOTAL:  %0d", passed + failed);
    $display("===========================================");
    endfunction
endclass