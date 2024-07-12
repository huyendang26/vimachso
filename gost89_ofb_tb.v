module gost89_ofb_tb;
  reg clk;
  always
    #1 clk = ~clk;

  reg  [255:0] key  = 256'h 0475f6e05038fbfad2c7c390edb3ca3d1547124291ae1e8a2f79cd9ed2bcefbd;
  wire mode_e = 0, mode_d = 1;
  reg reset;
  reg load_data;
  reg load_IV;
  reg [63:0] IV;
  reg [63:0] in_e;
  wire [63:0] out_e;
  wire busy_e;
  
  reg [63:0] in_d;
  wire[63:0] out_d;
  wire busy_d;

  gost89_ofb_encrypt
    ofb_encrypt(clk, reset, load_data, load_IV,  key, in_e, IV, out_e, busy_e);
  gost89_ofb_decrypt
    ofb_decrypt(clk, reset, load_data, load_IV,  key, in_d, IV, out_d, busy_d);


  initial begin
    clk = 0;
    reset = 0;
    load_data = 0;

// Normal usage
    #1;
    load_IV = 1;
    IV   = 64'h d5a8a608f4f115b4; 
    in_e = 64'h 0000000000000000; 
    #5;
    in_d = 64'h d658a36b11cf46eb;
    load_data = 1;
    #2;
    load_IV = 0;
    load_data = 0;
    #66;
    
// After reset
    #2;
    reset = 1;
    #2;
    reset = 0;
    #2;
//    in_e = 64'h 389eb44a391474c4; 
    #5;
    in_d = 64'h e0fca820fb3d9b0b;
    load_data = 1;
    #2;
    load_data = 0;
    #66;
    

// Reset in processing
    #2;
//    in_e = 64'h 0123456789abcdef; 
    #5;
    in_d = 64'h f9644ed22b21c5d7;

    load_data = 1;
    #2;
    load_data = 0;
    #12;
    reset = 1;
    #2;
    reset = 0;
    #2;
//    in_e = 64'h 379e59c3c96bb2ab; 
    #5;
    in_d = 64'h 583dee85ce821054;
    load_data = 1;
    #2;
    load_data = 0;
    #66;
    

// Start with reset
    #2;
    #5;
    in_e = 64'h 3b5834a000fba066; 
//    in_d = 64'h 3b5834a000fba066;

    load_data = 1;
    reset = 1;
    #2;
    load_data = 0;
    reset = 0;
    #66;

    $finish;
  end
endmodule