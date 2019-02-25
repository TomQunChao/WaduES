`timescale 1ns / 1ps

module bluetooth_tx(
input					clk_in,			//系统时钟
input					rst_n_in,		//系统复位，低有效
input					bps_clk,		//发送时钟输入
input					rx_bps_en,		//因需要自收自发，使用接收时钟使能判定：接收到新的数据，需要发送
input			[7:0]	tx_data,		//需要发出的数据

output	reg				bps_en,			//发送时钟使能
output	reg				tx		//UART发送输出
);
 
reg						rx_bps_en_r;
//延时锁存接收时钟使能信号
always @ (posedge clk_in or negedge rst_n_in) begin
	if(!rst_n_in) rx_bps_en_r <= 1'b0;
	else rx_bps_en_r <= rx_bps_en;
end
 
//检测接收时钟使能信号的下降沿，因为下降沿代表接收数据的完成，以此作为发送信号的激励
wire	neg_rx_bps_en = rx_bps_en_r & (~rx_bps_en);
 
reg				[3:0]	num;
reg				[9:0]	tx_data_r;	
//根据接收数据的完成，驱动发送数据操作
always @ (posedge clk_in or negedge rst_n_in) begin
	if(!rst_n_in) begin
		bps_en <= 1'b0;
		tx_data_r <= 8'd0;
	end else if(neg_rx_bps_en)begin	
		bps_en <= 1'b1;						//当检测到接收时钟使能信号的下降沿，表明接收完成，需要发送数据，使能发送时钟使能信号
		tx_data_r <= {1'b1,tx_data,1'b0};	
	end else if(num==4'd10) begin	
		bps_en <= 1'b0;	//一次UART发送需要10个时钟信号，然后结束
	end
end
 
//当处于工作状态中时，按照发送时钟的节拍发送数据
always @ (posedge clk_in or negedge rst_n_in) begin
	if(!rst_n_in) begin
		num <= 1'b0;
		tx <= 1'b1;
	end else if(bps_en) begin
		if(bps_clk) begin
			num <= num + 1'b1;
			tx <= tx_data_r[num];
		end else if(num>=4'd10) 
			num <= 4'd0;	
	end
end
 
endmodule
