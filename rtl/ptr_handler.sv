
module ptr_handler #(
    parameter integer PtrWidth = 2
) (
    input                     clk,
    input                     rst_n,
    input                     i_ptr_inc_en,
    output logic [PtrWidth:0] o_bin_ptr_comb,
    output logic [PtrWidth:0] o_bin_ptr,
    output logic [PtrWidth:0] o_gray_ptr
);
  logic              rst_sync_n;
  logic [PtrWidth:0] bin_ptr_d;
  logic [PtrWidth:0] gray_ptr_d;

  sync #(
      .NSync(2)
  ) inst_rst_sync (
      .clk,
      .rst_n,
      .i_async(1'b1),
      .o_sync (rst_sync_n)
  );

  always_comb begin
    if (i_ptr_inc_en) begin
      o_bin_ptr_comb = o_bin_ptr + 1'b1;
      gray_ptr_d     = (o_bin_ptr_comb >> 1) ^ o_bin_ptr_comb;
    end else begin
      o_bin_ptr_comb = o_bin_ptr;
      gray_ptr_d     = o_gray_ptr;
    end
  end

  always_ff @(posedge clk or negedge rst_sync_n) begin
    if (!rst_sync_n) begin
      o_bin_ptr  <= '0;
      o_gray_ptr <= '0;
    end else begin
      o_bin_ptr  <= o_bin_ptr_comb;
      o_gray_ptr <= gray_ptr_d;
    end

  end

endmodule
