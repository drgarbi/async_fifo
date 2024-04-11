// Asynchronous FIFO

`ifndef DEPTH
`define DEPTH 16
`endif  // DEPTH

`ifndef WIDTH
`define WIDTH 8
`endif  // WIDTH

module async_fifo #(
    parameter integer Depth = `DEPTH,
    parameter integer Width = `WIDTH
) (
    // Asynchronous reset
    input rst_n,

    // Write clock domain
    input             clk_wr,
    input             i_wr_en,
    input [Width-1:0] i_wr_data,

    // Read clock domain
    input              clk_rd,
    input              i_rd_en,
    output [Width-1:0] o_rd_data,

    output o_full,
    output o_empty
);
  localparam integer PtrWidth = $clog2(Depth);

  logic              rd_ptr_inc_en;
  logic [PtrWidth:0] rd_bin_ptr;
  logic [PtrWidth:0] rd_bin_ptr_comb;
  logic [PtrWidth:0] rd_gray_ptr;
  logic [PtrWidth:0] wr_gray_ptr_sync;

  logic              wr_ptr_inc_en;
  logic [PtrWidth:0] wr_bin_ptr;
  logic [PtrWidth:0] wr_bin_ptr_comb;
  logic [PtrWidth:0] wr_gray_ptr;
  logic [PtrWidth:0] rd_gray_ptr_sync;

  assign rd_ptr_inc_en = i_rd_en & ~o_empty;
  assign wr_ptr_inc_en = i_wr_en & ~o_full;

  dpram #(
      .Depth(Depth),
      .Width(Width)
  ) inst_dpram (
      .rst_n,
      .clk_wr,
      .i_wr_en,
      .i_wr_full (o_full),
      .i_wr_ptr  (wr_bin_ptr[PtrWidth-1:0]),
      .i_wr_data,
      .clk_rd,
      .i_rd_en,
      .i_rd_empty(o_empty),
      .i_rd_ptr  (rd_bin_ptr[PtrWidth-1:0]),
      .o_rd_data
  );

  ptr_handler #(
      .PtrWidth(PtrWidth)
  ) inst_rd_ptr_handler (
      .clk           (clk_rd),
      .rst_n,
      .i_ptr_inc_en  (rd_ptr_inc_en),
      .o_bin_ptr_comb(rd_bin_ptr_comb),
      .o_bin_ptr     (rd_bin_ptr),
      .o_gray_ptr    (rd_gray_ptr)
  );

  ptr_handler #(
      .PtrWidth(PtrWidth)
  ) inst_wr_ptr_handler (
      .clk           (clk_wr),
      .rst_n,
      .i_ptr_inc_en  (wr_ptr_inc_en),
      .o_bin_ptr_comb(wr_bin_ptr_comb),
      .o_bin_ptr     (wr_bin_ptr),
      .o_gray_ptr    (wr_gray_ptr)
  );

  sync #(
      .NSync(2),
      .Width(PtrWidth + 1)
  ) inst_rd_gray_ptr_sync (
      .clk    (clk_rd),
      .rst_n  (rst_n),
      .i_async(rd_gray_ptr),
      .o_sync (rd_gray_ptr_sync)
  );

  sync #(
      .NSync(2),
      .Width(PtrWidth + 1)
  ) inst_wr_gray_ptr_sync (
      .clk    (clk_wr),
      .rst_n  (rst_n),
      .i_async(wr_gray_ptr),
      .o_sync (wr_gray_ptr_sync)
  );

  empty_flag #(
      .PtrWidth(PtrWidth)
  ) inst_empty_flag (
      .clk               (clk_rd),
      .rst_n             (rst_n),
      .i_rd_bin_ptr      (rd_bin_ptr_comb),
      .i_wr_gray_ptr_sync(wr_gray_ptr_sync),
      .o_empty
  );

  full_flag #(
      .PtrWidth(PtrWidth)
  ) inst_full_flag (
      .clk               (clk_wr),
      .rst_n             (rst_n),
      .i_rd_gray_ptr_sync(rd_gray_ptr_sync),
      .i_wr_bin_ptr      (wr_bin_ptr_comb),
      .o_full
  );


endmodule
