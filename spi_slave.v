`timescale 1ns / 1ps

module spi_slave
(
    input rst,

    input sclk,
    input cs,
    input mosi,

    input [7:0] tx_data,

    output reg miso,
    output reg [7:0] rx_data,
    output reg done
);

reg [7:0] tx_shift;
reg [7:0] rx_shift;

reg [2:0] bit_cnt;

//------------------------------------------
// Load transmit data when CS goes LOW
//------------------------------------------
always @(negedge cs or posedge rst)
begin
    if(rst)
    begin
        tx_shift <= 8'h00;
        bit_cnt  <= 3'd7;
        miso     <= 1'b0;
        done     <= 1'b0;
    end
    else
    begin
        tx_shift <= tx_data;
        bit_cnt  <= 3'd7;
        miso     <= tx_data[7];
        done     <= 1'b0;
    end
end

//------------------------------------------
// Receive MOSI on Rising Edge
//------------------------------------------
always @(posedge sclk or posedge rst)
begin
    if(rst)
    begin
        rx_shift <= 8'h00;
        rx_data  <= 8'h00;
    end
    else if(!cs)
    begin
        rx_shift[bit_cnt] <= mosi;

        if(bit_cnt == 0)
        begin
            rx_data <= {rx_shift[7:1], mosi};
            done    <= 1'b1;
        end
    end
end

//------------------------------------------
// Shift MISO on Falling Edge
//------------------------------------------
always @(negedge sclk or posedge rst)
begin
    if(rst)
    begin
        tx_shift <= 8'h00;
    end
    else if(!cs)
    begin
        if(bit_cnt != 0)
        begin
            bit_cnt <= bit_cnt - 1;

            tx_shift <= {tx_shift[6:0],1'b0};

            miso <= tx_shift[6];
        end
    end
end

endmodule