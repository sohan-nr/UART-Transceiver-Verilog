module uart_tx
#(
    parameter DATA_BITS = 8
)
(
    input clk,
    input rst,

    input baud_tick,

    input tx_start,
    input [DATA_BITS-1:0] tx_data,

    output reg tx,
    output reg tx_busy,
    output reg tx_done
);

parameter IDLE  = 2'b00;
parameter START = 2'b01;
parameter DATA  = 2'b10;
parameter STOP  = 2'b11;

reg [1:0] state;

reg [DATA_BITS-1:0] shift_reg;

reg [3:0] bit_count;

always @(posedge clk)
begin

    if(rst)
    begin

        state      <= IDLE;
        tx         <= 1'b1;
        tx_busy    <= 1'b0;
        tx_done    <= 1'b0;

        shift_reg  <= 0;
        bit_count  <= 0;

    end

    else
    begin

        tx_done <= 1'b0;

        case(state)

        IDLE:
        begin

            tx <= 1'b1;
            tx_busy <= 1'b0;

            if(tx_start)
            begin

                shift_reg <= tx_data;
                bit_count <= 0;

                tx_busy <= 1'b1;

                state <= START;

            end

        end

        START:
        begin

            if(baud_tick)
            begin

                tx <= 1'b0;

                state <= DATA;

            end

        end

        DATA:
        begin

            if(baud_tick)
            begin

                tx <= shift_reg[0];

                shift_reg <= shift_reg >> 1;
                if(bit_count == DATA_BITS-1)
                begin

                    bit_count <= 0;

                    state <= STOP;

                end

                else
                begin

                    bit_count <= bit_count + 1;

                end

            end

        end

        STOP:
        begin

            if(baud_tick)
            begin

                tx <= 1'b1;

                tx_busy <= 1'b0;

                tx_done <= 1'b1;

                state <= IDLE;

            end

        end

        default:
        begin

            state <= IDLE;

        end

        endcase

    end

end

endmodule
