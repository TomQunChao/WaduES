`timescale 1ns / 1ps
/*Start conting only when it needs receive or send data*/
module bluetooth_divider(
    input clk,
    input rst_n,
    input bps_en,
    
    output reg clk_div
    );
    parameter CLK_PARAMA=10416;
    reg				[15:0]	cnt;
    //计数器计数满足波特率时钟要求
    always @ (posedge clk or negedge rst_n) begin
        if(!rst_n) 
            cnt <= 1'b0;
        else if((cnt >= CLK_PARAMA-1)||(!bps_en)) //当时钟信号不使能（bps_en为低电平）时，计数器清零并停止计数
            cnt <= 1'b0;                        //当时钟信号使能时，计数器对系统时钟计数，周期为BPS_PARA个系统时钟周期
        else 
            cnt <= cnt + 1'b1;
    end
     
    //产生相应波特率的时钟节拍，接收模块将以此节拍进行UART数据接收
    always @ (posedge clk or negedge rst_n)
        begin
            if(!rst_n) 
                clk_div <= 1'b0;
            else if(cnt == (CLK_PARAMA>>1))     //BPS_PARA右移一位等于除2，因计数器终值BPS_PARA为数据更替时间点，所以计数器中值时为数据最稳定时间点
                clk_div <= 1'b1;    
            else 
                clk_div <= 1'b0;
        end
endmodule
