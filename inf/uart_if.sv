/*
 * =====================================================
 * Created on Fri Mar 27 2026
 * University of Information Technology (UIT)
 * Copyright (c) 2026 Cong Nguyen
 * Email: congnguyen1024@gmail.com
 * =====================================================
 */
`timescale 1ns/1ps
interface uart_if(input logic clk, input logic rst);

    logic       i_Rx_Serial;  // driver drive cái này → DUT
    logic [7:0] o_Rx_Byte;    // DUT drive → monitor đọc
    logic       o_Rx_DV;      // DUT drive → monitor đọc

    // Clocking block cho driver — drive tín hiệu vào DUT
    clocking driver_cb @(posedge clk);
        default input #1step output #1;
        output i_Rx_Serial;
    endclocking

    // Clocking block cho monitor — sample tín hiệu từ DUT
    clocking monitor_cb @(posedge clk);
        default input #1step;
        input o_Rx_Byte;
        input o_Rx_DV;
        input i_Rx_Serial;  // monitor cũng cần biết đang drive gì
    endclocking

    // Reset task — dùng chung
    task do_reset();
        @(posedge clk);
        i_Rx_Serial <= 1'b1;  // UART idle = high
    endtask

endinterface
