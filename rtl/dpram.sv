// Dual-port RAM

module dpram #(
    parameter integer Depth = 8,
    parameter integer Width = 4,
    parameter integer PtrWidth = $clog2(Depth)
) (

    // Write clock domain
    input                clk_wr,
    input                i_wr_en,
    input                i_wr_full,
    input [PtrWidth-1:0] i_wr_ptr,
    input [   Width-1:0] i_wr_data,

    // Read clock domain
    input                       clk_rd,
    input                       rst_rd_n,
    input                       i_rd_en,
    input                       i_rd_empty,
    input        [PtrWidth-1:0] i_rd_ptr,
    output logic [   Width-1:0] o_rd_data
);
  logic [Width-1:0] ram[Depth];

  always_ff @(posedge clk_wr) begin
    if (i_wr_en && ~i_wr_full) begin
      ram[i_wr_ptr] <= i_wr_data;
    end
  end

  always_ff @(posedge clk_rd or negedge rst_rd_n) begin
    if (!rst_rd_n) begin
      o_rd_data <= '0;
    end else if (i_rd_en && ~i_rd_empty) begin
      o_rd_data <= ram[i_rd_ptr];
    end
  end

endmodule
