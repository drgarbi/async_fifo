// Asynchronous FIFO

`ifndef DEPTH
`define DEPTH 4
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

  logic rst_rd_n;
  logic [PtrWidth:0] rd_bin_ptr;
  logic [PtrWidth:0] rd_gray_ptr;
  logic [PtrWidth:0] wr_gray_ptr_sync;

  logic rst_wr_n;
  logic [PtrWidth:0] wr_bin_ptr;
  logic [PtrWidth:0] wr_gray_ptr;
  logic [PtrWidth:0] rd_gray_ptr_sync;

  sync #(
      .NSync(2),
      .Width(1)
  ) inst_rst_rd_n (
      .clk    (clk_rd),
      .rst_n  (rst_n),
      .i_async(1'b1),
      .o_sync (rst_rd_n)
  );

  sync #(
      .NSync(2),
      .Width(1)
  ) inst_rst_wr_n (
      .clk    (clk_wr),
      .rst_n  (rst_n),
      .i_async(1'b1),
      .o_sync (rst_wr_n)
  );

  dpram #(
      .Depth(Depth),
      .Width(Width)
  ) inst_dpram (
      .clk_wr,
      .i_wr_en,
      .i_wr_full (o_full),
      .i_wr_ptr  (wr_bin_ptr[PtrWidth-1:0]),
      .i_wr_data,
      .clk_rd,
      .rst_rd_n,
      .i_rd_en,
      .i_rd_empty(o_empty),
      .i_rd_ptr  (rd_bin_ptr[PtrWidth-1:0]),
      .o_rd_data
  );

  read_control #(
      .PtrWidth(PtrWidth)
  ) inst_read_control (
      .clk_rd,
      .rst_rd_n,
      .i_rd_en,
      .i_wr_gray_ptr_sync(wr_gray_ptr_sync),
      .o_bin_ptr         (rd_bin_ptr),
      .o_gray_ptr        (rd_gray_ptr),
      .o_empty
  );

  write_control #(
      .PtrWidth(PtrWidth)
  ) inst_write_control (
      .clk_wr,
      .rst_wr_n,
      .i_wr_en,
      .i_rd_gray_ptr_sync(rd_gray_ptr_sync),
      .o_bin_ptr         (wr_bin_ptr),
      .o_gray_ptr        (wr_gray_ptr),
      .o_full
  );

  sync #(
      .NSync(2),
      .Width(PtrWidth + 1)
  ) inst_rd_gray_ptr_sync (
      .clk    (clk_wr),
      .rst_n  (rst_n),
      .i_async(rd_gray_ptr),
      .o_sync (rd_gray_ptr_sync)
  );

  sync #(
      .NSync(2),
      .Width(PtrWidth + 1)
  ) inst_wr_gray_ptr_sync (
      .clk    (clk_rd),
      .rst_n  (rst_n),
      .i_async(wr_gray_ptr),
      .o_sync (wr_gray_ptr_sync)
  );

endmodule
