module TX (input clk, rst, par_typ, par_en, data_valid,
    input [7:0] p_data, 
    output reg tx_out, busy);

integer i;
reg [7:0] data_container;
reg [2:0] cs, ns;

localparam IDLE = 3'b000, T_PARE = 3'b001, T_PARO = 3'b010, T_NPAR = 3'b011,
    T_PARE2 = 3'b100, T_PARO2 = 3'b101, T_NPAR2 = 3'b110;

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
            tx_out = 1'b0;
            busy = 1'b0;
            i = 0;
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
            busy = 1'b1;
            if (i == 0) begin
                tx_out = 1'b0;
                i = i + 1;
                ns = T_PARE2;
            end
            else if (i > 0 && i < 9) begin
                tx_out = data_container [i - 1];
                i = i + 1;
                ns = T_PARE2;
            end
            else if (i == 9) begin
                tx_out = ~(^data_container);
                i = i + 1;
                ns = T_PARE2;
            end
            else begin
                tx_out = 1'b1;
                ns = IDLE;
            end
        end
        T_PARE2: begin
            busy = 1'b1;
            if (i == 0) begin
                tx_out = 1'b0;
                i = i + 1;
                ns = T_PARE;
            end
            else if (i > 0 && i < 9) begin
                tx_out = data_container [i - 1];
                i = i + 1;
                ns = T_PARE;
            end
            else if (i == 9) begin
                tx_out = ~(^data_container);
                i = i + 1;
                ns = T_PARE;
            end
            else begin
                tx_out = 1'b1;
                ns = IDLE;
            end
        end
        T_PARO: begin
            busy = 1'b1;
            if (i == 0) begin
                tx_out = 1'b0;
                i = i + 1;
                ns = T_PARO2;
            end
            else if (i > 0 && i < 9) begin
                tx_out = data_container [i - 1];
                i = i + 1;
                ns = T_PARO2;
            end
            else if (i == 9) begin
                tx_out = ^data_container;
                i = i + 1;
                ns = T_PARO2;
            end
            else begin
                tx_out = 1'b1;
                ns = IDLE;
            end
        end
        T_PARO2: begin
            busy = 1'b1;
            if (i == 0) begin
                tx_out = 1'b0;
                i = i + 1;
                ns = T_PARO;
            end
            else if (i > 0 && i < 9) begin
                tx_out = data_container [i - 1];
                i = i + 1;
                ns = T_PARO;
            end
            else if (i == 9) begin
                tx_out = ^data_container;
                i = i + 1;
                ns = T_PARO;
            end
            else begin
                tx_out = 1'b1;
                ns = IDLE;
            end
        end
        T_NPAR: begin
            busy = 1'b1;
            if (i == 0) begin
                tx_out = 1'b0;
                i = i + 1;
                ns = T_NPAR2;
            end
            else if (i > 0 && i < 9) begin
                tx_out = data_container [i - 1];
                i = i + 1;
                ns = T_NPAR2;
            end
            else begin
                tx_out = 1'b1;
                ns = IDLE;
            end
        end
        T_NPAR2: begin
            busy = 1'b1;
            if (i == 0) begin
                tx_out = 1'b0;
                i = i + 1;
                ns = T_NPAR;
            end
            else if (i > 0 && i < 9) begin
                tx_out = data_container [i - 1];
                i = i + 1;
                ns = T_NPAR;
            end
            else begin
                tx_out = 1'b1;
                ns = IDLE;
            end
        end
        default: begin
            tx_out = 1'b0;
            busy = 1'b0;
        end
    endcase
end
endmodule