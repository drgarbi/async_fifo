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

    output o_wr_full,
    output o_rd_empty
);

  localparam integer PtrWidth = $clog2(Width);

  dpram #(
      .Depth(Depth),
      .Width(Width)
  ) inst_dpram (
      .rst_n,
      .clk_wr,
      .i_wr_en,
      .i_wr_full (o_wr_full),
      .i_wr_ptr  ({PtrWidth{1'b0}}),
      .i_wr_data,
      .clk_rd,
      .i_rd_en,
      .i_rd_empty(o_rd_empty),
      .i_rd_ptr  ({PtrWidth{1'b0}}),
      .o_rd_data
  );


endmodule
