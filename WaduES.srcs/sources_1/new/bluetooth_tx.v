`timescale 1ns / 1ps

module bluetooth_tx(
input					clk_in,			//ϵͳʱ��
input					rst_n_in,		//ϵͳ��λ������Ч
input					bps_clk,		//����ʱ������
input					rx_bps_en,		//����Ҫ�����Է���ʹ�ý���ʱ��ʹ���ж������յ��µ����ݣ���Ҫ����
input			[7:0]	tx_data,		//��Ҫ����������

output	reg				bps_en,			//����ʱ��ʹ��
output	reg				tx		//UART�������
);
 
reg						rx_bps_en_r;
//��ʱ�������ʱ��ʹ���ź�
always @ (posedge clk_in or negedge rst_n_in) begin
	if(!rst_n_in) rx_bps_en_r <= 1'b0;
	else rx_bps_en_r <= rx_bps_en;
end
 
//������ʱ��ʹ���źŵ��½��أ���Ϊ�½��ش���������ݵ���ɣ��Դ���Ϊ�����źŵļ���
wire	neg_rx_bps_en = rx_bps_en_r & (~rx_bps_en);
 
reg				[3:0]	num;
reg				[9:0]	tx_data_r;	
//���ݽ������ݵ���ɣ������������ݲ���
always @ (posedge clk_in or negedge rst_n_in) begin
	if(!rst_n_in) begin
		bps_en <= 1'b0;
		tx_data_r <= 8'd0;
	end else if(neg_rx_bps_en)begin	
		bps_en <= 1'b1;						//����⵽����ʱ��ʹ���źŵ��½��أ�����������ɣ���Ҫ�������ݣ�ʹ�ܷ���ʱ��ʹ���ź�
		tx_data_r <= {1'b1,tx_data,1'b0};	
	end else if(num==4'd10) begin	
		bps_en <= 1'b0;	//һ��UART������Ҫ10��ʱ���źţ�Ȼ�����
	end
end
 
//�����ڹ���״̬��ʱ�����շ���ʱ�ӵĽ��ķ�������
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
