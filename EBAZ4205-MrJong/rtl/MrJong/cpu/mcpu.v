
module mcpu(
  input         clk_sys,
  input         reset,
  input  [7:0]  cpu_din,
  output [7:0]  cpu_dout,
  output [15:0] cpu_ab,
  output        cpu_wr,
  output        cpu_rd,
  output        cpu_io,
  output        cpu_m1,
  input         vb
);

wire cen_26;
reg [7:0] hold_nmi;
wire        cpu_rd_n;
wire        cpu_wr_n;
wire        cpu_m1_n;
wire        cpu_mreq_n;
wire        cpu_iorq_n;
wire        cpu_rfsh_n;
wire        cpu_nmi_n = ~|hold_nmi;
wire        cpu_wait_n = 1'b1;

assign cpu_io = ~cpu_iorq_n;
assign cpu_m1 = ~cpu_m1_n;
assign cpu_wr = ~cpu_wr_n;
assign cpu_rd = ~cpu_rd_n;


clk_en #(17) cpu_clk_en(clk_sys, cen_26);

reg old_vb;

reg [7:0] data_latch;
always @(posedge clk_sys) begin
  old_vb <= vb;
  if (~old_vb & vb) hold_nmi <= 8'hff;
  if (hold_nmi != 8'd0) hold_nmi <= hold_nmi - 8'd1;
  if (~cpu_rd_n) data_latch <= cpu_din;
end

// Enable the R (refresh) register,
// it is used as a source for random number generation
`define TV80_REFRESH 1
tv80s cpu(
  .reset_n ( ~reset      ),
  .clk     ( clk_sys     ),
  .cen     ( cen_26      ),
  .wait_n  ( cpu_wait_n  ),
  .int_n   ( 1'b1        ),
  .nmi_n   ( cpu_nmi_n   ),
  .busrq_n ( 1'b1        ),
  .m1_n    ( cpu_m1_n    ),
  .mreq_n  ( cpu_mreq_n  ),
  .iorq_n  ( cpu_iorq_n  ),
  .rd_n    ( cpu_rd_n    ),
  .wr_n    ( cpu_wr_n    ),
  .rfsh_n  ( cpu_rfsh_n  ),
  .halt_n  (             ),
  .busak_n (             ),
  .A       ( cpu_ab      ),
  .di      ( data_latch  ),
  .dout    ( cpu_dout    )
);

endmodule
