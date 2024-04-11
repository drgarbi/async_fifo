// N-stage flip-flop synchronizer

module sync #(
    parameter integer NSYNC = 2
) (
    input  clk,
    input  rst_n,
    input  i_async,
    output o_sync
);
  logic sync[NSYNC];

  assign o_sync = sync[NSYNC-1];

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      sync[0] <= 1'b0;
    end else begin
      sync[0] <= i_async;
    end
  end

  genvar i;
  for (i = 1; i < NSYNC; i++) begin : gen_sync
    always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
        sync[i] <= 1'b0;
      end else begin
        sync[i] <= sync[i-1];
      end
    end
  end

endmodule
