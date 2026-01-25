class generator;
    mailbox #(transaction) gen2drv;
    int num_transaction = 0;

    function new(mailbox #(transaction) g2d,int num = 20);
        this.num_transaction = num;
        this.gen2drv = g2d;
    endfunction 

    task run();
        transaction trans;
        $display("[GENERATOR] Starting generation of %0d transactions", num_transaction);
      for (int i = 1; i <= num_transaction; i++) begin
            trans = new();
            if(!trans.randomize)begin
                $error("Randomization faild!");
            end
          
            gen2drv.put(trans);  
        	$display("[GENERATOR] Generated Trans #%0d: A=%h, B=%h, Cin=%h", i, trans.A, trans.B, trans.cin);        
        end
        $display("[GENERATOR] Generation complete");
    endtask
endclass