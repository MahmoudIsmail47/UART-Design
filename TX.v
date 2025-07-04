module TX (input clk, rst, par_typ, par_en, data_valid,
    input [7:0] p_data, 
    output reg tx_out, busy);

integer i;
reg [7:0] data_container;

always @ (posedge clk) begin


endmodule