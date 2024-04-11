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

  task automatic writeData(input logic [Width-1] data);
    #2;
    i_wr_en   = 1'b1;
    i_wr_data = data;
    #2;
    i_wr_en = 1'b0;
  endtask

  task automatic readData(output logic [Width-1] data);
    #2;
    i_rd_en = 1'b1;
    #2;
    i_rd_en = 1'b0;
    data    = o_rd_data;
  endtask

  initial begin
    logic [Width-1:0] received_data;
    $dumpfile("async_fifo_tb.vcd");
    $dumpvars(0, async_fifo_tb);

    $monitor("At time %0t, i_wr_data = 0x%h (%0d), o_rd_data = 0x%h (%0d)", $time, i_wr_data,
             i_wr_data, o_rd_data, o_rd_data);

    clk_wr    = 1'b0;
    i_wr_en   = 1'b0;
    i_wr_data = '0;
    clk_rd    = 1'b0;
    i_rd_en   = 1'b0;
    rst_n     = 1'b0;
    #2;
    rst_n = 1'b1;
    #2;

    writeData($urandom);
    readData(received_data);
    writeData($urandom);
    readData(received_data);
    writeData($urandom);
    readData(received_data);

    #4 $finish;
  end

endmodule
