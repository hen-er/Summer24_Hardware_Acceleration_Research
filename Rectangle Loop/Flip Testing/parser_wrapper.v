
module parser_wrapper(
    input         clk,
    input         reset,
    input         start,
    input [15:0]  from_pc,
    output [15:0] to_pc
);
    reg [15:0]  base_addr;
    reg [1:0]  r1, r2, c1, c2;
    wire [15:0] flipped_data;
    wire done; //can probably exclude this
    
    //edge-detect on start to create a one-cycle pulse
    reg start_d, start_p;
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            start_d <= 0;
            start_p <= 0;
            base_addr <= 0;
            r1        <= 0;
            r2        <= 0;
            c1        <= 0;
            c2        <= 0;
        end
        else begin
            start_p <= start & ~start_d;
            start_d <= start;
	    base_addr <= from_pc[15:8];
            r1        <= from_pc[7:6];
            r2        <= from_pc[5:4];
            c1        <= from_pc[3:2];
            c2        <= from_pc[1:0];
        end
    end

    flip_controller #(
	.ROWS (4),
	.COLS (4),
	.DATA_WIDTH (8)
	 ) controller_inst (
        .clk(clk),
        .reset(reset),
        .start(start_p),
        .base_addr(base_addr),
        .r1(r1),
        .r2(r2),
        .c1(c1),
        .c2(c2),
        .done(done),
        .flipped_out(flipped_data)
    );
    
    assign to_pc = flipped_data;
endmodule
