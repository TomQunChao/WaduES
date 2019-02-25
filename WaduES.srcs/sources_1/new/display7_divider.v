`timescale 1ns / 1ps

module display7_divider(
    input clk,
    input rst_n,
    
    output clk_div
    );
    parameter CLK_PARAMA=200000;
    reg [31:0]cnt;
    always @ (posedge clk)
    begin
        if(!rst_n)cnt=0;
        else
        begin
            if(cnt==CLK_PARAMA)
            begin
                cnt=0;
            end
            else cnt=cnt+1'b1;
        end
    end
    assign clk_div=cnt>CLK_PARAMA/2?1:0;
endmodule
