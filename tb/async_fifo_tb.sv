// Asynchronous FIFO testbench
`timescale 1ps / 1ps

`ifndef DEPTH
`define DEPTH 8
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
  logic             o_full;
  logic             o_empty;

  logic             rst_complete;


  async_fifo #(
      .Depth(Depth),
      .Width(Width)
  ) inst_async_fifo (
      .*
  );

  always #1 clk_wr = ~clk_wr;
  always #1.5 clk_rd = ~clk_rd;

  task automatic writeData(input logic [Width-1] data);
    i_wr_en   = 1'b1;
    i_wr_data = data;
    #2;
    i_wr_en = 1'b0;
  endtask

  task automatic readData(output logic [Width-1] data);
    i_rd_en = 1'b1;
    data    = o_rd_data;
    #3;
    i_rd_en = 1'b0;
  endtask

  // Dump array elements
  genvar idx;
  for (idx = 0; idx < Depth; idx = idx + 1) begin : g_dump
    initial $dumpvars(0, async_fifo_tb.inst_async_fifo.inst_dpram.ram[idx]);
  end

  always @(negedge clk_wr) begin
    if (!o_full && rst_complete) writeData($urandom);
  end

  always @(negedge clk_rd) begin
    logic [Width-1:0] received_data;
    if (!o_empty && rst_complete) readData(received_data);
  end

  initial #100 $finish;

  initial begin
    $dumpvars(0, async_fifo_tb);
    $monitor("At time %0t, i_wr_data = 0x%h (%0d), o_rd_data = 0x%h (%0d)", $time, i_wr_data,
             i_wr_data, o_rd_data, o_rd_data);

    rst_complete = 1'b0;
    clk_wr       = 1'b0;
    i_wr_en      = 1'b0;
    i_wr_data    = '0;
    clk_rd       = 1'b0;
    i_rd_en      = 1'b0;
    rst_n        = 1'b0;
    #2;
    rst_n = 1'b1;
    #10;
    rst_complete = 1'b1;
  end
endmodule
