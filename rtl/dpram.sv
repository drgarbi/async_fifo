// Dual-port RAM

module dpram #(
    parameter integer Depth = 8,
    parameter integer Width = 4,
    parameter integer PtrWidth = $clog2(Depth)
) (
    // Asynchronous reset
    input rst_n,

    // Write clock domain
    input                clk_wr,
    input                i_wr_en,
    input                i_wr_full,
    input [PtrWidth-1:0] i_wr_ptr,
    input [   Width-1:0] i_wr_data,

    // Read clock domain
    input                 clk_rd,
    input                 i_rd_en,
    input                 i_rd_empty,
    input  [PtrWidth-1:0] i_rd_ptr,
    output [   Width-1:0] o_rd_data
);
  reg [Width-1:0] ram[Depth];

  always_ff @(posedge clk_wr or negedge rst_n) begin
    if (!rst_n) i_wr_ptr <= '0;
    else if (i_wr_en && ~i_wr_full) begin
      i_wr_ptr      <= i_wr_ptr + 1'b1;
      ram[i_wr_ptr] <= i_wr_data;
    end
  end

  always_ff @(posedge clk_rd or negedge rst_n) begin
    if (!rst_n) begin
      i_rd_ptr  <= '0;
      o_rd_data <= '0;
    end else if (i_rd_en && ~i_rd_empty) begin
      i_rd_ptr  <= i_rd_ptr + 1'b1;
      o_rd_data <= ram[i_wr_ptr];
    end
  end

endmodule
