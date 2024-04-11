module gray2bin #(
    parameter integer Width = 4
) (
    input  [Width-1:0] i_gray,
    output [Width-1:0] o_bin
);

  genvar i;
  for (i = 0; i < Width; i++) begin : g_g2b
    assign o_bin[i] = ^(i_gray >> i);
  end


endmodule
