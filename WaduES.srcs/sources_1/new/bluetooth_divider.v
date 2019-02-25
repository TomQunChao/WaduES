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
    //�������������㲨����ʱ��Ҫ��
    always @ (posedge clk or negedge rst_n) begin
        if(!rst_n) 
            cnt <= 1'b0;
        else if((cnt >= CLK_PARAMA-1)||(!bps_en)) //��ʱ���źŲ�ʹ�ܣ�bps_enΪ�͵�ƽ��ʱ�����������㲢ֹͣ����
            cnt <= 1'b0;                        //��ʱ���ź�ʹ��ʱ����������ϵͳʱ�Ӽ���������ΪBPS_PARA��ϵͳʱ������
        else 
            cnt <= cnt + 1'b1;
    end
     
    //������Ӧ�����ʵ�ʱ�ӽ��ģ�����ģ�齫�Դ˽��Ľ���UART���ݽ���
    always @ (posedge clk or negedge rst_n)
        begin
            if(!rst_n) 
                clk_div <= 1'b0;
            else if(cnt == (CLK_PARAMA>>1))     //BPS_PARA����һλ���ڳ�2�����������ֵBPS_PARAΪ���ݸ���ʱ��㣬���Լ�������ֵʱΪ�������ȶ�ʱ���
                clk_div <= 1'b1;    
            else 
                clk_div <= 1'b0;
        end
endmodule
