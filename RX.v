module RX (input clk, rst, par_en, par_typ, rx_in, start,
    output reg [7:0] p_data,
    output reg data_valid, par_error, stop_error);

integer i;
reg [2:0] cs, ns;

localparam IDLE = 3'b000, R_PARE = 3'b001, R_PARO = 3'b010, R_NPAR = 3'b011,
    R_PARE2 = 3'b100, R_PARO2 = 3'b101, R_NPAR2 = 3'b110;

always @ (posedge clk) begin
    if (rst == 1'b0) begin
        cs <= IDLE;
    end
    else begin
        cs <= ns;
    end
end

always @ (*) begin
    case (cs)
        IDLE: begin
            p_data = 8'b0;
            data_valid = 1'b0;
            par_error = 1'b0;
            stop_error = 1'b0;
            i = 0;
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
            if (i == 0) begin
                i = i + 1;
                p_data = 8'b0;
                data_valid = 1'b0;
                par_error = 1'b0;
                stop_error = 1'b0;
                ns = R_PARE2;
            end
            else if (i >= 1 && i <= 8) begin
                i = i + 1;
                p_data[i - 1] = rx_in;
                data_valid = 1'b0;
                par_error = 1'b0;
                stop_error = 1'b0;
                ns = R_PARE2;
            end
            else if (i == 9) begin
                i = i + 1;
                p_data = p_data;
                data_valid = 1'b0;
                stop_error = 1'b0;
                ns = R_PARE2;
                if (~(^p_data) == rx_in) begin
                    par_error = 1'b0;
                end
                else begin
                    par_error = 1'b1;
                end
            end
            else begin
                p_data = p_data;
                data_valid = 1'b1;
                ns = IDLE;
                par_error = par_error;
                if (rx_in == 1'b1) begin
                    stop_error = 1'b0;
                end
                else begin
                    stop_error = 1'b1;
                end
            end
        end
        R_PARE2: begin
            if (i == 0) begin
                i = i + 1;
                p_data = 8'b0;
                data_valid = 1'b0;
                par_error = 1'b0;
                stop_error = 1'b0;
                ns = R_PARE;
            end
            else if (i >= 1 && i <= 8) begin
                i = i + 1;
                p_data[i - 1] = rx_in;
                data_valid = 1'b0;
                par_error = 1'b0;
                stop_error = 1'b0;
                ns = R_PARE;
            end
            else if (i == 9) begin
                i = i + 1;
                p_data = p_data;
                data_valid = 1'b0;
                stop_error = 1'b0;
                ns = R_PARE;
                if (~(^p_data) == rx_in) begin
                    par_error = 1'b0;
                end
                else begin
                    par_error = 1'b1;
                end
            end
            else begin
                p_data = p_data;
                data_valid = 1'b1;
                ns = IDLE;
                par_error = par_error;
                if (rx_in == 1'b1) begin
                    stop_error = 1'b0;
                end
                else begin
                    stop_error = 1'b1;
                end
            end
        end
        R_PARO: begin
            if (i == 0) begin
                i = i + 1;
                p_data = 8'b0;
                data_valid = 1'b0;
                par_error = 1'b0;
                stop_error = 1'b0;
                ns = R_PARO2;
            end
            else if (i >= 1 && i <= 8) begin
                i = i + 1;
                p_data[i - 1] = rx_in;
                data_valid = 1'b0;
                par_error = 1'b0;
                stop_error = 1'b0;
                ns = R_PARO2;
            end
            else if (i == 9) begin
                i = i + 1;
                p_data = p_data;
                data_valid = 1'b0;
                stop_error = 1'b0;
                ns = R_PARO2;
                if ((^p_data) == rx_in) begin
                    par_error = 1'b0;
                end
                else begin
                    par_error = 1'b1;
                end
            end
            else begin
                p_data = p_data;
                data_valid = 1'b1;
                ns = IDLE;
                par_error = par_error;
                if (rx_in == 1'b1) begin
                    stop_error = 1'b0;
                end
                else begin
                    stop_error = 1'b1;
                end
            end
        end
        R_PARO: begin
            if (i == 0) begin
                i = i + 1;
                p_data = 8'b0;
                data_valid = 1'b0;
                par_error = 1'b0;
                stop_error = 1'b0;
                ns = R_PARO;
            end
            else if (i >= 1 && i <= 8) begin
                i = i + 1;
                p_data[i - 1] = rx_in;
                data_valid = 1'b0;
                par_error = 1'b0;
                stop_error = 1'b0;
                ns = R_PARO;
            end
            else if (i == 9) begin
                i = i + 1;
                p_data = p_data;
                data_valid = 1'b0;
                stop_error = 1'b0;
                ns = R_PARO;
                if ((^p_data) == rx_in) begin
                    par_error = 1'b0;
                end
                else begin
                    par_error = 1'b1;
                end
            end
            else begin
                p_data = p_data;
                data_valid = 1'b1;
                ns = IDLE;
                par_error = par_error;
                if (rx_in == 1'b1) begin
                    stop_error = 1'b0;
                end
                else begin
                    stop_error = 1'b1;
                end
            end
        end
        R_NPAR: begin
            if (i == 0) begin
                i = i + 1;
                p_data = 8'b0;
                data_valid = 1'b0;
                stop_error = 1'b0;
                ns = R_NPAR2;
            end
            else if (i >= 1 && i <= 8) begin
                i = i + 1;
                p_data[i - 1] = rx_in;
                data_valid = 1'b0;
                stop_error = 1'b0;
                ns = R_NPAR2;
            end
            else begin
                p_data = p_data;
                par_error = 1'b0;
                data_valid = 1'b1;
                ns = IDLE;
                if (rx_in == 1'b1) begin
                    stop_error = 1'b0;
                end
                else begin
                    stop_error = 1'b1;
                end
            end
        end
        R_NPAR2: begin
            if (i == 0) begin
                i = i + 1;
                p_data = 8'b0;
                data_valid = 1'b0;
                stop_error = 1'b0;
                ns = R_NPAR;
            end
            else if (i >= 1 && i <= 8) begin
                i = i + 1;
                p_data[i - 1] = rx_in;
                data_valid = 1'b0;
                stop_error = 1'b0;
                ns = R_NPAR;
            end
            else begin
                p_data = p_data;
                par_error = 1'b0;
                data_valid = 1'b1;
                ns = IDLE;
                if (rx_in == 1'b1) begin
                    stop_error = 1'b0;
                end
                else begin
                    stop_error = 1'b1;
                end
            end
        end
    endcase
end
endmodule