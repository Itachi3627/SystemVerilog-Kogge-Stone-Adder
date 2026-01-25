class driver;
    mailbox #(transaction) gen2drv;
    transaction trans;
    virtual intf.driver vif;

    function new(virtual intf.driver vif, mailbox #(transaction) g2d);
        this.vif = vif;
        this.gen2drv = g2d;
    endfunction

    task run();
        $display("[DRIVER] Starting driver");
        forever begin
          gen2drv.get(trans);
          vif.A = trans.A;
          vif.B = trans.B;
          vif.cin = trans.cin;
          #5;
          ->vif.sample_enable;
          #5;
          
        end

    endtask

endclass 