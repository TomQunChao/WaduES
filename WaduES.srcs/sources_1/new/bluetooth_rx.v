
`timescale 1ns / 1ps
/*This module is for debugging*/
module bluetooth_rx(
input					clk_in,			//系统时钟
input					rst_n_in,		//系统复位，低有效
input					bps_clk,		//接收时钟输入 
input					rx,		//UART接收输入

output	reg				bps_en,			//接收时钟使能
output	reg		[7:0]	rx_data			//接收到的数据
);	
 
reg	rs232_rx0,rs232_rx1,rs232_rx2;	
//多级延时锁存去除亚稳态
always @ (posedge clk_in or negedge rst_n_in) begin
	if(!rst_n_in) begin
		rs232_rx0 <= 1'b0;
		rs232_rx1 <= 1'b0;
		rs232_rx2 <= 1'b0;
	end else begin
		rs232_rx0 <= rx;
		rs232_rx1 <= rs232_rx0;
		rs232_rx2 <= rs232_rx1;
	end
end
 
//检测UART接收输入信号的下降沿
wire	neg_rs232_rx = rs232_rx2 & rs232_rx1 & (~rs232_rx0) & (~rx);
 
reg				[3:0]	num;			
//接收时钟使能信号的控制
always @ (posedge clk_in or negedge rst_n_in) begin
	if(!rst_n_in)
		bps_en <= 1'b0;
	else if(neg_rs232_rx && (!bps_en))	//当空闲状态（bps_en为低电平）时检测到UART接收信号下降沿，进入工作状态（bps_en为高电平），控制时钟模块产生接收时钟
		bps_en <= 1'b1;
	else if(num==4'd9)		      		//当完成一次UART接收操作后，退出工作状态，恢复空闲状态
		bps_en <= 1'b0;			
end
 
reg				[7:0]	rx_data_r;
//当处于工作状态中时，按照接收时钟的节拍获取数据
always @ (posedge clk_in or negedge rst_n_in) begin
	if(!rst_n_in) begin
		num <= 4'd0;
		rx_data <= 8'd0;
		rx_data_r <= 8'd0;
	end else if(bps_en) begin	
		if(bps_clk) begin			
			num <= num+1'b1;
			if(num<=4'd8)
			rx_data_r[num-1]<=rx;	//先接受低位再接收高位，8位有效数据
		end else if(num == 4'd9) begin	//完成一次UART接收操作后，将获取的数据输出
			num <= 4'd0;
			rx_data <= rx_data_r;	
		end
	end
end
 
endmodule
