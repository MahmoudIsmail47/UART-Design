module TX_optimized (input clk, rst, par_typ, par_en, data_valid, prescale,
    input [7:0] p_data, 
    output reg tx_out, busy);

integer i;
reg [7:0] data_container;
reg [1:0] cs, ns;
wire clk_in;
reg flare;

localparam IDLE = 2'b00, T_PARE = 2'b01, T_PARO = 2'b10, T_NPAR = 2'b11;

OVS ovs (.clk(clk), .prescale(prescale), .clk_out(clk_in));

always @ (posedge clk_in) begin
    if (rst == 1'b0) cs <= IDLE;
    else cs <= ns;

    if (flare) i <= i + 1;
    else i <= 0;
end

always @ (*) begin
    case (cs)
        IDLE: begin
            tx_out = 1'b0;
            busy = 1'b0;
            flare = 0;
            if (data_valid == 1'b1) begin
                data_container = p_data;
                case ({par_en , par_typ})
                    2'b10: ns = T_PARE;
                    2'b11: ns = T_PARO;  
                    default: ns = T_NPAR;
                endcase
            end
            else begin
                ns = IDLE;
            end            
        end
        T_PARE: begin
            flare = 1;
            busy = 1'b1;
            if (i == 0) begin
                tx_out = 1'b0;
                ns = T_PARE;
            end
            else if (i > 0 && i < 9) begin
                tx_out = data_container [i - 1];
                ns = T_PARE;
            end
            else if (i == 9) begin
                tx_out = ^data_container;
                ns = T_PARE;
            end
            else begin
                tx_out = 1'b1;
                ns = IDLE;
            end            
        end
        T_PARO: begin
            busy = 1'b1;
            flare = 1;
            if (i == 0) begin
                tx_out = 1'b0;
                ns = T_PARO;
            end
            else if (i > 0 && i < 9) begin
                tx_out = data_container [i - 1];
                ns = T_PARO;
            end
            else if (i == 9) begin
                tx_out = ~(^data_container);
                ns = T_PARO;
            end
            else begin
                tx_out = 1'b1;
                ns = IDLE;
            end
        end
        T_NPAR: begin
            busy = 1'b1;
            flare = 1;
            if (i == 0) begin
                tx_out = 1'b0;
                ns = T_NPAR;
            end
            else if (i > 0 && i < 9) begin
                tx_out = data_container [i - 1];
                ns = T_NPAR;
            end
            else begin
                tx_out = 1'b1;
                ns = IDLE;
            end
        end
    endcase
end
endmodule
