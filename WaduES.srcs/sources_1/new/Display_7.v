`timescale 1ns / 1ps

module Display_7(
    input [3:0]es0,
    input [3:0]es1,
    input clk,
    //input rst_n,
    
    output reg[6:0]display,
    output display_dp,
    output [5:0]sleep_pos,
    output reg en0,
    output reg en1
    );
    reg en;
    reg [3:0]data;
    
    always @ (posedge clk)
    begin 
        en=~en;
    end
    always @ (en)
    begin
        case(en)
            1'b0:
            begin
                data=es0;
                en0=0;
                en1=1;
            end
            1'b1:
            begin
                data=es1;
                en0=1;
                en1=0;
            end
        endcase
    end
    always @(en)
    begin
        case(data)
            0:display = 7'b0000001; // 0
            1:display = 7'b1001111; // 1
            2: display = 7'b0010010; // 2
            3: display = 7'b0000110; // 3
            4: display = 7'b1001100; // 4
            5: display = 7'b0100100; // 5
            6: display = 7'b0100000; // 6
            7: display = 7'b0001111; // 7
            8: display = 7'b0000000; // 8
            9: display = 7'b0000100; // 9
            10: display = 7'b0001000; // A
            11: display = 7'b1100000; // b
            12: display = 7'b0110001; // c
            13: display = 7'b1000010; // d
            14: display = 7'b0110000; // E
            15: display = 7'b0111000; // F
            default: display = 7'b1111111;
        endcase
    end
    assign sleep_pos=6'b111111;
  
    assign display_dp=~en0;
endmodule
