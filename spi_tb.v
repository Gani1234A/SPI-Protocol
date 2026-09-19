`timescale 1ns/1ps

module spi_tb;

reg clk;
reg rst;
reg start;

reg [7:0] master_tx;
reg [7:0] slave_tx;

wire sclk;
wire cs;
wire mosi;
wire miso;

wire [7:0] master_rx;
wire [7:0] slave_rx;

wire busy;
wire done;
wire slave_done;

//////////////////////////////////////////////////////////
// Clock Generation (100MHz)
//////////////////////////////////////////////////////////

always #5 clk = ~clk;

//////////////////////////////////////////////////////////
// Master
//////////////////////////////////////////////////////////

spi_master uut_master
(
    .clk(clk),
    .rst(rst),
    .start(start),

    .tx_data(master_tx),

    .miso(miso),

    .sclk(sclk),
    .mosi(mosi),
    .cs(cs),

    .rx_data(master_rx),

    .busy(busy),
    .done(done)
);

//////////////////////////////////////////////////////////
// Slave
//////////////////////////////////////////////////////////

spi_slave uut_slave
(
    .rst(rst),

    .sclk(sclk),
    .cs(cs),
    .mosi(mosi),

    .tx_data(slave_tx),

    .miso(miso),

    .rx_data(slave_rx),

    .done(slave_done)
);

//////////////////////////////////////////////////////////
// Test
//////////////////////////////////////////////////////////

initial
begin

    clk = 0;
    rst = 1;
    start = 0;

    master_tx = 8'h00;
    slave_tx  = 8'h00;

    #40;

    rst = 0;

    //----------------------------------------
    // Transaction-1
    //----------------------------------------

    master_tx = 8'hA5;
    slave_tx  = 8'h3C;

    #20;

    start = 1;

    #10;

    start = 0;

    wait(done);

    #50;

    $display("--------------------------------");
    $display("Transaction 1");
    $display("--------------------------------");
    $display("Master TX : %h", master_tx);
    $display("Slave RX  : %h", slave_rx);

    $display("Slave TX  : %h", slave_tx);
    $display("Master RX : %h", master_rx);

    //----------------------------------------
    // Transaction-2
    //----------------------------------------

    #100;


    master_tx = 8'h55;
    slave_tx  = 8'hAA;

    start = 1;

    #10;

    start = 0;

    wait(done);

    #50;

    $display("--------------------------------");
    $display("Transaction 2");
    $display("--------------------------------");
    $display("Master TX : %h", master_tx);
    $display("Slave RX  : %h", slave_rx);

    $display("Slave TX  : %h", slave_tx);
    $display("Master RX : %h", master_rx);

    #100;

    $finish;

end

//////////////////////////////////////////////////////////
// Waveform
//////////////////////////////////////////////////////////

initial
begin

    $dumpfile("spi.vcd");

    $dumpvars(0,spi_tb);

end

endmodule