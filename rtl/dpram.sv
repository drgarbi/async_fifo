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
    input                       clk_rd,
    input                       i_rd_en,
    input                       i_rd_empty,
    input        [PtrWidth-1:0] i_rd_ptr,
    output logic [   Width-1:0] o_rd_data
);
  logic [Width-1:0] ram[Depth];
  logic rst_sync0_n;
  logic rst_sync1_n;

  always_ff @(posedge clk_rd or negedge rst_n) begin
    if (!rst_n) begin
      rst_sync0_n <= 1'b0;
      rst_sync1_n <= 1'b0;
    end else begin
      rst_sync0_n <= 1'b1;
      rst_sync1_n <= rst_sync0_n;
    end
  end

  always_ff @(posedge clk_wr) begin
    if (i_wr_en && ~i_wr_full) begin
      ram[i_wr_ptr] <= i_wr_data;
    end
  end

  always_ff @(posedge clk_rd or negedge rst_sync1_n) begin
    if (!rst_sync1_n) begin
      o_rd_data <= '0;
    end else if (i_rd_en && ~i_rd_empty) begin
      o_rd_data <= ram[i_wr_ptr];
    end
  end

endmodule
