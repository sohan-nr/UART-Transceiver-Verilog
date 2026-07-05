`timescale 1ns/1ps

module uart_top_tb;

reg clk;
reg rst;
reg tx_start;
reg [7:0] tx_data;

wire tx;
wire rx;

wire [7:0] rx_data;

wire tx_busy;
wire tx_done;
wire rx_done;

//-----------------------------------
// Loopback Connection
//-----------------------------------
assign rx = tx;

//-----------------------------------
// DUT
//-----------------------------------
uart_top DUT(

    .clk(clk),
    .rst(rst),

    .tx_start(tx_start),
    .tx_data(tx_data),

    .rx(rx),

    .tx(tx),

    .rx_data(rx_data),

    .tx_busy(tx_busy),
    .tx_done(tx_done),

    .rx_done(rx_done)

);

//-----------------------------------
// Clock Generation
//-----------------------------------
always #5 clk = ~clk;

//-----------------------------------
// Test Sequence
//-----------------------------------
initial
begin

    clk = 0;
    rst = 1;
    tx_start = 0;
    tx_data = 8'h00;

    #20;
    rst = 0;

    //-----------------------
    // Byte 1
    //-----------------------
    #20;
    tx_data = 8'hA5;
    tx_start = 1;

    #10;
    tx_start = 0;

    wait(rx_done);

    //-----------------------
    // Byte 2
    //-----------------------
    #40;
    tx_data = 8'h55;
    tx_start = 1;

    #10;
    tx_start = 0;

    wait(rx_done);

    //-----------------------
    // Byte 3
    //-----------------------
    #40;
    tx_data = 8'h3C;
    tx_start = 1;

    #10;
    tx_start = 0;

    wait(rx_done);

    #100;

    $finish;

end

//-----------------------------------
// Waveform
//-----------------------------------
initial
begin

    $dumpfile("uart_top.vcd");
    $dumpvars(0, uart_top_tb);

end

endmodule
