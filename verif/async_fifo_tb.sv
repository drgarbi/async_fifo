// Asynchronous FIFO testbench
`timescale 1ps / 1ps

`ifndef DEPTH
`define DEPTH 4
`endif  // DEPTH

`ifndef WIDTH
`define WIDTH 8
`endif  // WIDTH

module async_fifo_tb;

  localparam integer Width = `WIDTH;
  localparam integer Depth = `DEPTH;


  logic             rst_n;
  logic             clk_wr;
  logic             i_wr_en;
  logic [Width-1:0] i_wr_data;
  logic             clk_rd;
  logic             i_rd_en;
  logic [Width-1:0] o_rd_data;
  logic             o_wr_full;
  logic             o_rd_empty;


  async_fifo #(
      .Depth(Depth),
      .Width(Width)
  ) inst_async_fifo (
      .*
  );

  always #1 begin
    clk_wr = ~clk_wr;
    clk_rd = ~clk_rd;
  end

  initial begin
    clk_wr = 1'b0;
    clk_rd = 1'b0;

    #100 $finish;
  end

endmodule
