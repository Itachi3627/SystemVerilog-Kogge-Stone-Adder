class monitor;
    mailbox #(transaction) mon2scb;
    transaction trans;
    virtual intf.monitor vif;
    mailbox #(transaction) mon2cov;

    function new(virtual intf.monitor vif, mailbox #(transaction) m2s, mailbox #(transaction) m2c);
        this.vif = vif;
        this.mon2scb = m2s;
        this.mon2cov = m2c; // [New]
    endfunction

    task run();
        $display("[Monitor] Starting monitor");
        forever begin
          @(vif.sample_enable);

            trans = new();

            trans.A = vif.A;
            trans.B = vif.B;
            trans.cin = vif.cin;
            trans.sum = vif.sum;
            trans.cout = vif.cout;

            mon2scb.put(trans);
            mon2cov.put(trans);
          $display("-----------------------------------------------------------------------------------------------------------------------");        

          $display("[Monitor] Captured Trans: A=%h, B=%h, Cin=%h, Sum=%h, Cout=%h", trans.A, trans.B, trans.cin, trans.sum, trans.cout);        
        end
    endtask


endclass