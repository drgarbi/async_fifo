module empty_flag #(
    parameter integer PtrWidth = 2
) (
    input                     clk,
    input                     rst_n,
    input        [PtrWidth:0] i_rd_bin_ptr,
    input        [PtrWidth:0] i_wr_gray_ptr_sync,
    output logic              o_empty
);
  logic              rst_sync_n;
  logic [PtrWidth:0] wr_bin_ptr_sync;

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
      .i_gray(i_wr_gray_ptr_sync),
      .o_bin (wr_bin_ptr_sync)
  );

  always_ff @(posedge clk or negedge rst_sync_n) begin
    if (!rst_sync_n) begin
      o_empty <= 1'b0;
    end else begin
      o_empty <= i_rd_bin_ptr == wr_bin_ptr_sync;
    end
  end

endmodule
