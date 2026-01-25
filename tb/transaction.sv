class transaction #(parameter WIDTH = 16);
    rand logic [WIDTH-1:0] A;
    rand logic [WIDTH-1:0] B;
    rand logic             cin;
    logic [WIDTH-1:0] sum;
    logic             cout;


    constraint c_coverage_dist{
      A dist { 
      16'h0000                := 20, 
      [16'h0001 : 16'h5555]   :/ 20, 
      [16'h5556 : 16'hAAAA]   :/ 20, 
      [16'hAAAB : 16'hFFFE]   :/ 20, 
      16'hFFFF                := 20  
    };


    B dist { 
      16'h0000                := 20,
      [16'h0001 : 16'h5555]   :/ 20,
      [16'h5556 : 16'hAAAA]   :/ 20,
      [16'hAAAB : 16'hFFFE]   :/ 20,
      16'hFFFF                := 20
    };
    
    cin dist { 0 := 50, 1 := 50 };


    }

endclass