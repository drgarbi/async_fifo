// N-stage flip-flop synchronizer

module sync #(
    parameter integer NSync = 2,
    parameter integer Width = 1
) (
    input              clk,
    input              rst_n,
    input  [Width-1:0] i_async,
    output [Width-1:0] o_sync
);
  logic [Width-1:0] sync[NSync];

  assign o_sync = sync[NSync-1];

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      sync[0] <= {Width{1'b0}};
    end else begin
      sync[0] <= i_async;
    end
  end

  genvar i;
  for (i = 1; i < NSync; i++) begin : gen_sync
    always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
        sync[i] <= {Width{1'b0}};
      end else begin
        sync[i] <= sync[i-1];
      end
    end
  end

endmodule
