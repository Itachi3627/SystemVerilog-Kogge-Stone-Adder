interface intf #(parameter WIDTH = 16);
    logic [WIDTH-1:0] A;
    logic [WIDTH-1:0] B;
    logic             cin;
    logic [WIDTH-1:0] sum;
    logic             cout;

    event sample_enable;

    modport driver(
        input sum, cout,
        output A, B, cin
    );

    modport dut(
            output sum, cout,
            input A, B, cin
    );

    modport monitor(
            input sum, cout,
            input A, B, cin
    );


    
endinterface