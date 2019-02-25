`timescale 1ns / 1ps

module oled_tb;
    reg clk;
    reg rst_n;
    reg [2:0]oled_cmd;
    wire oled_rst;
    wire oled_clk;
    wire oled_cs;
    wire oled_data_out;
    wire oled_dc;
    wire oled_run_flag;
    
    Control c(clk,rst_n,oled_start,oled_cmd,oled_rst,oled_clk,oled_cs,oled_data_out,oled_dc,oled_run_flag);
    initial clk=0;
    always #5 clk=~clk;
    initial
    begin
        rst_n=0;
        #40;
        rst_n=1;
        #5000000;
        rst_n=0;
        #20;
    end
    
endmodule
