module full_flag #(
    parameter integer PtrWidth = 2
) (
    input                     clk,
    input                     rst_n,
    input        [PtrWidth:0] i_rd_gray_ptr_sync,
    input        [PtrWidth:0] i_wr_bin_ptr,
    output logic              o_full
);
  logic rst_sync_n;
  logic [PtrWidth:0] rd_bin_ptr_sync;

  sync #(
      .NSync(2)
  ) inst_rst_sync (
      .clk    (clk),
      .rst_n  (rst_n),
      .i_async(1'b1),
      .o_sync (rst_sync_n)
  );

  gray2bin #(
      .Width(PtrWidth + 1)
  ) inst_gray2bin (
      .i_gray(i_rd_gray_ptr_sync),
      .o_bin (rd_bin_ptr_sync)
  );

  always_ff @(posedge clk or negedge rst_sync_n) begin
    if (!rst_sync_n) begin
      o_full <= 1'b0;
    end else begin
      o_full <= (i_wr_bin_ptr[PtrWidth] ^ rd_bin_ptr_sync[PtrWidth])
      & i_wr_bin_ptr[PtrWidth-1:0] == rd_bin_ptr_sync[PtrWidth-1:0];
    end
  end

endmodule
