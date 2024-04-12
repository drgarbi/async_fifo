module read_control #(
    parameter integer PtrWidth = 2
) (
    input                     clk_rd,
    input                     rst_rd_n,
    input                     i_rd_en,
    input        [PtrWidth:0] i_wr_gray_ptr_sync,
    output logic [PtrWidth:0] o_bin_ptr,
    output logic [PtrWidth:0] o_gray_ptr,
    output logic              o_empty
);
  logic [PtrWidth:0] bin_ptr_d;
  logic [PtrWidth:0] gray_ptr_d;
  logic              empty_d;

  assign empty_d = gray_ptr_d == i_wr_gray_ptr_sync;

  always_comb begin
    if (i_rd_en & ~o_empty) begin
      bin_ptr_d  = o_bin_ptr + 1'b1;
      gray_ptr_d = (bin_ptr_d >> 1) ^ bin_ptr_d;
    end else begin
      bin_ptr_d  = o_bin_ptr;
      gray_ptr_d = o_gray_ptr;
    end
  end

  always_ff @(posedge clk_rd or negedge rst_rd_n) begin
    if (!rst_rd_n) begin
      o_bin_ptr  <= '0;
      o_gray_ptr <= '0;
      o_empty    <= 1'b1;
    end else begin
      o_bin_ptr  <= bin_ptr_d;
      o_gray_ptr <= gray_ptr_d;
      o_empty    <= empty_d;
    end
  end

endmodule
