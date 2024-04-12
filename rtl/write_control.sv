module write_control #(
    parameter integer PtrWidth = 2
) (
    input                     clk_wr,
    input                     rst_wr_n,
    input                     i_wr_en,
    input        [PtrWidth:0] i_rd_gray_ptr_sync,
    output logic [PtrWidth:0] o_bin_ptr,
    output logic [PtrWidth:0] o_gray_ptr,
    output logic              o_full
);
  logic [PtrWidth:0] bin_ptr_d;
  logic [PtrWidth:0] gray_ptr_d;
  logic              full_d;

  assign full_d = gray_ptr_d ==
      {~i_rd_gray_ptr_sync[PtrWidth:PtrWidth-1], i_rd_gray_ptr_sync[PtrWidth-2:0]};

  always_comb begin
    if (i_wr_en & ~o_full) begin
      bin_ptr_d  = o_bin_ptr + 1'b1;
      gray_ptr_d = (bin_ptr_d >> 1) ^ bin_ptr_d;
    end else begin
      bin_ptr_d  = o_bin_ptr;
      gray_ptr_d = o_gray_ptr;
    end
  end

  always_ff @(posedge clk_wr or negedge rst_wr_n) begin
    if (!rst_wr_n) begin
      o_bin_ptr  <= '0;
      o_gray_ptr <= '0;
      o_full     <= 1'b0;
    end else begin
      o_bin_ptr  <= bin_ptr_d;
      o_gray_ptr <= gray_ptr_d;
      o_full     <= full_d;
    end
  end
endmodule
