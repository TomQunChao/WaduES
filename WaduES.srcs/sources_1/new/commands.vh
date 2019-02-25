

parameter CLK_DIV_PERIOD=10000; //related with clk_div's frequency
parameter DELAY_PERIOD=25000;  //related with delay time and refresh frequency
 
parameter CLK_L=2'd0;
parameter CLK_H=2'd1;
parameter CLK_RISING_DEGE=2'd2;
parameter CLK_FALLING_DEGE=2'd3;
 
parameter IDLE=3'd0;
parameter SHIFT=3'd1;
parameter CLEAR=3'd2;
parameter SETXY=3'd3;
parameter DISPLAY=3'd4;
parameter DELAY=3'd5;
 
parameter LOW =1'b0;
parameter HIGH =1'b1;
parameter CMD =1'b0;
parameter DATA =1'b1;
 
//assign oled_rst_n_out = 1;  //active low level, set 1 for normal
//assign oled_dc_out = 1;
 
    parameter DRAW_LINE                    =8'h21;
    parameter DRAW_RECTANGLE               =8'h22;
    parameter COPY_WINDOW                  =8'h23;
    parameter DIM_WINDOW                   =8'h24;
    parameter CLEAR_WINDOW                 =8'h25;
    parameter FILL_WINDOW                  =8'h26;
    parameter DISABLE_FILL                 =8'h00;
    parameter ENABLE_FILL                  =8'h01;
    parameter CONTINUOUS_SCROLLING_SETUP   =8'h27;
    parameter DEACTIVE_SCROLLING           =8'h2E;
    parameter ACTIVE_SCROLLING             =8'h2F;
    
    parameter SET_COLUMN_ADDRESS           =8'h15;
    parameter SET_ROW_ADDRESS              =8'h75;
    parameter SET_CONTRAST_A               =8'h81;
    parameter SET_CONTRAST_B               =8'h82;
    parameter SET_CONTRAST_C               =8'h83;
    parameter MASTER_CURRENT_CONTROL       =8'h87;
    parameter SET_PRECHARGE_SPEED_A        =8'h8A;
    parameter SET_PRECHARGE_SPEED_B        =8'h8B;
    parameter SET_PRECHARGE_SPEED_C        =8'h8C;
    parameter SET_REMAP                    =8'hA0;
    parameter SET_DISPLAY_START_LINE       =8'hA1;
    parameter SET_DISPLAY_OFFSET           =8'hA2;
    parameter NORMAL_DISPLAY               =8'hA4;
    parameter ENTIRE_DISPLAY_ON            =8'hA5;
    parameter ENTIRE_DISPLAY_OFF           =8'hA6;
    parameter INVERSE_DISPLAY              =8'hA7;
    parameter SET_MULTIPLEX_RATIO          =8'hA8;
    parameter DIM_MODE_SETTING             =8'hAB;
    parameter SET_MASTER_CONFIGURATION         =8'hAD;
    parameter DIM_MODE_DISPLAY_ON          =8'hAC;
    parameter DISPLAY_OFF                  =8'hAE;
    parameter NORMAL_BRIGHTNESS_DISPLAY_ON =8'hAF;
    parameter POWER_SAVE_MODE              =8'hB0;
    parameter PHASE_PERIOD_ADJUSTMENT      =8'hB1;
    parameter DISPLAY_CLOCK_DIV            =8'hB3;
    parameter SET_GRAy_SCALE_TABLE         =8'hB8;
    parameter ENABLE_LINEAR_GRAY_SCALE_TABLE  =8'hB9;
    parameter SET_PRECHARGE_VOLTAGE=8'hBB;
    parameter OLED_NOP1=8'hBC;
    parameter DISPLAY_CLOCK_DIVIDER=8'hF0;
    parameter SET_VCOMH=8'hBE;
    parameter SET_V_VOLTAGE=8'hBE;
    
    parameter ULX3S_REMAP = 8'h22;
    