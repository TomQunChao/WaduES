
`timescale 1ns / 1ps
/*This module is for debugging*/
module bluetooth_rx(
input					clk_in,			//ϵͳʱ��
input					rst_n_in,		//ϵͳ��λ������Ч
input					bps_clk,		//����ʱ������ 
input					rx,		//UART��������

output	reg				bps_en,			//����ʱ��ʹ��
output	reg		[7:0]	rx_data			//���յ�������
);	
 
reg	rs232_rx0,rs232_rx1,rs232_rx2;	
//�༶��ʱ����ȥ������̬
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
 
//���UART���������źŵ��½���
wire	neg_rs232_rx = rs232_rx2 & rs232_rx1 & (~rs232_rx0) & (~rx);
 
reg				[3:0]	num;			
//����ʱ��ʹ���źŵĿ���
always @ (posedge clk_in or negedge rst_n_in) begin
	if(!rst_n_in)
		bps_en <= 1'b0;
	else if(neg_rs232_rx && (!bps_en))	//������״̬��bps_enΪ�͵�ƽ��ʱ��⵽UART�����ź��½��أ����빤��״̬��bps_enΪ�ߵ�ƽ��������ʱ��ģ���������ʱ��
		bps_en <= 1'b1;
	else if(num==4'd9)		      		//�����һ��UART���ղ������˳�����״̬���ָ�����״̬
		bps_en <= 1'b0;			
end
 
reg				[7:0]	rx_data_r;
//�����ڹ���״̬��ʱ�����ս���ʱ�ӵĽ��Ļ�ȡ����
always @ (posedge clk_in or negedge rst_n_in) begin
	if(!rst_n_in) begin
		num <= 4'd0;
		rx_data <= 8'd0;
		rx_data_r <= 8'd0;
	end else if(bps_en) begin	
		if(bps_clk) begin			
			num <= num+1'b1;
			if(num<=4'd8)
			rx_data_r[num-1]<=rx;	//�Ƚ��ܵ�λ�ٽ��ո�λ��8λ��Ч����
		end else if(num == 4'd9) begin	//���һ��UART���ղ����󣬽���ȡ���������
			num <= 4'd0;
			rx_data <= rx_data_r;	
		end
	end
end
 
endmodule
