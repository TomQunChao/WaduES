`timescale 1ns / 1ps


module Control(
    input clk,
    input rst_n,
    
    input bl_rx,
    
    output oled_rst,
    output oled_clk,
    output oled_cs,
    output oled_data_out,
    output oled_dc,
    output oled_run_flag,
    
    output bl_tx,
    output bluetooth_en,
    
    output [6:0]display7,
    output display7_dp,
    output en0,
    output en1,
    output [5:0]sleep_pos,
    output over
    
//    input [1:0]pos,
//    input [3:0]sizes
    );
    
    wire [1:0]posi;
    wire [3:0]size;
    
    
    wire [63:0]reac0;
    wire [63:0]reac1;
    wire [63:0]reac2;
    wire [63:0]reac3;
    
    wire [3:0]es0;
    wire [3:0]es1;
    
    wire [7:0]bl_data;//data bluetooth received
    wire rx_bps_en;//whether bluetooth received data completely
    Zoomer z(
        .size(size),//TODO
        
        .posi(posi),//TODO
        
        .reac0(reac0),
        .reac1(reac1),
        .reac2(reac2),
        .reac3(reac3)
        );
    
    cal_es ce(
        .clk(clk),
        .cur_pos(posi),
        .user_input(bl_data),
        .rst_n(rst_n),
        .rx_en(rx_bps_en),
        
        .es({es1,es0}),
        .size(size),
        .over(over)
        );
    Display_OLED d(
        .reac0(reac0),
        .reac1(reac1),
        .reac2(reac2),
        .reac3(reac3),
        .size(size),
        
        .clk_in(clk),
        .rst_n_in(rst_n), 
        
        .run_flag(oled_run_flag),
        .oled_rst_n_out(oled_rst),
        .oled_cs_n_out(oled_cs),
        .oled_dc_out(oled_dc),
        .oled_clk_out(oled_clk),
        .oled_data_out(oled_data_out)
        );
    
    wire br_clk;
    wire bt_clk;
    
    wire tx_bps_en;
    bluetooth_divider brd(
        .clk(clk),
        .rst_n(rst_n),
        .bps_en(rx_bps_en),
        
        .clk_div(br_clk)
        );
    bluetooth_rx br(
        .clk_in(clk),			//ϵͳʱ��
        .rst_n_in(rst_n),        //ϵͳ��λ������Ч
        .bps_clk(br_clk),        //����ʱ������ 
        .rx(bl_rx),//UART��������
    
        .bps_en(rx_bps_en),            //����ʱ��ʹ��
        .rx_data(bl_data)//���յ�������
        );
     bluetooth_divider btd(
          .clk(clk),
          .rst_n(rst_n),
          .bps_en(tx_bps_en),
          
          .clk_div(bt_clk)
          );
     bluetooth_tx bt(
        .clk_in(clk),//ϵͳʱ��
        .rst_n_in(rst_n), //ϵͳ��λ������Ч
        .bps_clk(bt_clk),//����ʱ������
        .rx_bps_en(rx_bps_en),//����Ҫ�����Է���ʹ�ý���ʱ��ʹ���ж������յ��µ����ݣ���Ҫ����
        .tx_data(bl_data),//��Ҫ����������
     
        .bps_en(tx_bps_en),//����ʱ��ʹ��
        .tx(bl_tx)//UART�������
        );
     
     wire display7_clk;
     display7_divider d7d(
        .clk(clk),
        .rst_n(rst_n),
         
        .clk_div(display7_clk)
        );
//    reg [3:0]es0=4'h7;
//    reg [3:0]es1=4'h9;
    Display_7 d7(
        .es0(es0),
        .es1(es1),
        .clk(display7_clk),
        
        .display(display7),
        .display_dp(display7_dp),
        .en0(en0),
        .en1(en1),
        .sleep_pos(sleep_pos)
        );
     
endmodule
