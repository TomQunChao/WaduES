`timescale 1ns / 1ps

module cal_es(
    input clk,
    input [1:0]cur_pos,
    input [7:0]user_input,
    input rst_n,
    input rx_en,
    
    output reg [7:0]es,
    output reg [3:0]size,
    output reg over
    );
    
    reg rx_en_r;
    always @ (posedge clk or negedge rst_n)
    begin
        if(!rst_n)rx_en_r=1'b0;
        else rx_en_r=rx_en;
    end
    reg [3:0]last_size;
    reg [3:0]last_last;
    reg [1:0]user_pos;
    reg [7:0]user_input_r;
    initial size=4'h3;
    initial last_size=4'hF;
    initial last_last=4'h3;
    initial es=8'h14;
    wire neg_rx_en=rx_en_r&~rx_en;
    always @ (posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            size<=4'h3;
            es<=8'h14;
            last_size<=4'hF;
            last_last=4'h3;
            over=0;
        end
        else if(neg_rx_en)
        begin
            user_input_r=user_input;
            case (user_input_r)
                8'h55:user_pos=2'b11;//Up/top
                8'h4C:user_pos=2'b00;//Left/left
                8'h44:user_pos=2'b01;//Down/bottom
                8'h52:user_pos=2'b10;//Right/right
                default:user_pos=2'b00;
            endcase
            if(user_pos==cur_pos)
            begin
                size=size-1'b1;
            end
            else
            begin
                size=size+1'b1;
            end
            if(last_last==size||size==4'h0||size==4'h9)over=1;
            else
            begin
                last_last=last_size;
                 last_size=size;
            end
            case(size)
                4'h0:es=8'h20;
                4'h1:es=8'h18;
                4'h2:es=8'h16;
                4'h3:es=8'h14;
                4'h4:es=8'h12;
                4'h5:es=8'h10;
                4'h6:es=8'h08;
                4'h7:es=8'h06;
                4'h8:es=8'h04;
                4'h9:es=8'h02;
                default:es<=8'hFF;
            endcase
        end
    end
    assign user_in=user_input_r;
    assign user_p=user_pos;
    
endmodule
