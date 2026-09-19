`timescale 1ns/1ps

module spi_top(

    input clk,
    input rst,
    input start,

    input [7:0] master_tx_data,
    input [7:0] slave_tx_data,

    output [7:0] master_rx_data,
    output [7:0] slave_rx_data,

    output busy,
    output done,

    output sclk,
    output cs,
    output mosi,
    output miso

);

//////////////////////////////////////////////////
// SPI Master
//////////////////////////////////////////////////

spi_master MASTER
(
    .clk(clk),
    .rst(rst),

    .start(start),

    .tx_data(master_tx_data),

    .miso(miso),

    .sclk(sclk),
    .mosi(mosi),
    .cs(cs),

    .rx_data(master_rx_data),

    .busy(busy),
    .done(done)
);

//////////////////////////////////////////////////
// SPI Slave
//////////////////////////////////////////////////

wire slave_done;

spi_slave SLAVE
(
    .rst(rst),

    .sclk(sclk),
    .cs(cs),

    .mosi(mosi),

    .tx_data(slave_tx_data),

    .miso(miso),

    .rx_data(slave_rx_data),

    .done(slave_done)
);

endmodule