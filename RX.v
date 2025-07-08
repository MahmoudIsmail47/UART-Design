module RX_optimized (input clk, rst, par_en, par_typ, rx_in, start,
    output reg [7:0] p_data,
    output reg data_valid, par_error, stop_error);

integer i;
reg [1:0] cs, ns;
reg flare;

localparam IDLE = 2'b00, R_PARE = 2'b01, R_PARO = 2'b10, R_NPAR = 2'b11;

always @ (posedge clk) begin
    if (rst == 1'b0) cs <= IDLE;
    else cs <= ns;

    if (flare) i <= i + 1;
    else i <= 0;
end

always @ (*) begin
    case (cs)
        IDLE: begin
            p_data = 8'b0;
            data_valid = 1'b0;
            par_error = 1'b0;
            stop_error = 1'b0;
            flare = 0;
            if (start) begin
                case ({par_en , par_typ})
                    2'b10: ns = R_PARE;
                    2'b11: ns = R_PARO;
                    default: ns = R_NPAR;
                endcase
            end
            else begin
                ns = IDLE;
            end            
        end
        R_PARE: begin
            p_data = p_data;
            data_valid = data_valid;
            par_error = par_error;
            stop_error = stop_error;
            if (start == 1'b0) begin
                ns = IDLE;
            end
            else if (i == 0) begin
                flare = 1;
                ns = R_PARE;
            end
            else if (i> 0 && i < 9) begin
                p_data[i - 1] = rx_in;
                flare = 1;
                ns = R_PARE;
            end
            else if (i == 9) begin
                if ((^p_data) == rx_in) begin
                    par_error = 1'b0;
                end
                else begin
                    par_error = 1'b1;
                end
                flare = 1;
                ns = R_PARE;
            end
            else begin
                data_valid = 1'b1;
                if (rx_in == 1'b1) begin
                    stop_error = 1'b0;
                end
                else begin
                    stop_error = 1'b1;
                end
                ns = IDLE;
            end
        end
        R_PARO: begin
            p_data = p_data;
            data_valid = data_valid;
            par_error = par_error;
            stop_error = stop_error;
            if (start == 1'b0) begin
                ns = IDLE;
            end
            else if (i == 0) begin
                flare = 1;
                ns = R_PARO;
            end
            else if (i> 0 && i < 9) begin
                p_data[i - 1] = rx_in;
                flare = 1;
                ns = R_PARO;
            end
            else if (i == 9) begin
                if (~(^p_data) == rx_in) begin
                    par_error = 1'b0;
                end
                else begin
                    par_error = 1'b1;
                end
                flare = 1;
                ns = R_PARO;
            end
            else begin
                data_valid = 1'b1;
                if (rx_in == 1'b1) begin
                    stop_error = 1'b0;
                end
                else begin
                    stop_error = 1'b1;
                end
                ns = IDLE;
            end
        end
        R_NPAR: begin
            flare = 1;
            p_data = p_data;
            data_valid = data_valid;
            par_error = 1'b0;
            stop_error = stop_error;
            if (start == 1'b0) begin
                ns = IDLE;
            end
            else if (i == 0) begin
                flare = 1;
                ns = R_PARO;
            end
            else if (i> 0 && i < 9) begin
                p_data[i - 1] = rx_in;
                flare = 1;
                ns = R_PARO;
            end
            else begin
                data_valid = 1'b1;
                if (rx_in == 1'b1) begin
                    stop_error = 1'b0;
                end
                else begin
                    stop_error = 1'b1;
                end
                ns = IDLE;
            end
        end
    endcase
end
endmodule
