module gost89_ofb_encrypt(
  input              clk,
  input              reset,
  input              load_data,
  input              load_IV,
//  input      [511:0] sbox,
  input      [255:0] key,
  input      [63:0]  in,
  input      [63:0]  IV,
  
  output     [63:0]  out,
  output reg         busy
);
  reg  [5:0]  round_num;
  reg  [31:0] n1, n2, round_key;
  reg  [63:0] fb;
  
  wire [31:0] out1, out2;
  wire  [511:0] sbox;
  
  //reg  [255:0] key;
  //assign key = 256'h0475f6e05038fbfad2c7c390edb3ca3d1547124291ae1e8a2f79cd9ed2bcefbd;
  assign sbox = 512'h4a92d80e6b1c7f53eb4c6dfa23810759581da342efc7609b7da1089fe46cb2536c715fd84a9e03b24ba0721d36859cfedb413f590ae7682c1fd057a4923e6b8c;
  gost89_round
    rnd(clk, sbox, round_key, n1, n2, out1, out2);

  always @(posedge clk) begin
    if (load_data) begin
      busy <= 1;
      round_num <= 0;
      if (load_IV) begin
        n1 <= IV[63:32];
        n2 <= IV[31:0];
      end
      else begin
        n1 <= fb[63:32];
        n2 <= fb[31:0];
      end
    end

    if (reset && !load_data) begin
      busy <= 0;
      round_num <= 32;
    end

    if (!reset && !load_data) begin
      if (round_num < 32)
        round_num <= round_num + 1;
      if (round_num > 0 && round_num < 32) begin
        n1 <= out1;
        n2 <= out2;
      end
      if (round_num == 32) begin
        fb[63:32] <= out2;
        fb[31:0]  <= out1;
        busy <= 0;
      end
    end
  end
  
  assign out = fb ^ in;
  
  always @(posedge clk)
    case (round_num)
      0:  round_key <= key[255:224];
      1:  round_key <= key[223:192];
      2:  round_key <= key[191:160];
      3:  round_key <= key[159:128];
      4:  round_key <= key[127:96];
      5:  round_key <= key[95:64];
      6:  round_key <= key[63:32];
      7:  round_key <= key[31:0];
      8:  round_key <= key[255:224];
      9:  round_key <= key[223:192];
      10: round_key <= key[191:160];
      11: round_key <= key[159:128];
      12: round_key <= key[127:96];
      13: round_key <= key[95:64];
      14: round_key <= key[63:32];
      15: round_key <= key[31:0];
      16: round_key <= key[255:224];
      17: round_key <= key[223:192];
      18: round_key <= key[191:160];
      19: round_key <= key[159:128];
      20: round_key <= key[127:96];
      21: round_key <= key[95:64];
      22: round_key <= key[63:32];
      23: round_key <= key[31:0];
      24: round_key <= key[31:0];
      25: round_key <= key[63:32];
      26: round_key <= key[95:64];
      27: round_key <= key[127:96];
      28: round_key <= key[159:128];
      29: round_key <= key[191:160];
      30: round_key <= key[223:192];
      31: round_key <= key[255:224];
    endcase
endmodule
