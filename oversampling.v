module CLK_DIV (input clk, prescale, output reg clk_out);

integer i;
reg flare;


always @ (*) begin
    if (prescale) begin
        flare = 1;
        if (i%4 && i < 4) begin
            clk_out = 1'b1;
        end
        else if (i%7) begin
            clk_out = 1'b0;
            if (i == 6) begin
                flare = 0;
            end
            else begin
                flare = 1;
            end
        end
        else begin
            flare = 0;
            clk_out = clk;
        end
    end
    else begin
        flare = 0;
        clk_out = clk;
    end
end

always @ (posedge clk) begin
    if (flare) begin
        i = i + 1;
    end
    else begin
        i = 1;
    end
end
endmodule