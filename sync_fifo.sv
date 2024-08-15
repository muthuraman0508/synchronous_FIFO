
module sync_fifo #(
  parameter int DEPTH =16 ,
parameter int WIDTH =8 ,
  parameter int PTR_WIDTH =$clog2(DEPTH))(
	input clk,
	input rst,
	input wr_en,
	input rd_en,
	input [WIDTH-1:0]wdata,
	output reg [WIDTH-1:0]rdata,
	output reg wr_error,
	output reg rd_error);

	integer i;
	reg full;
	reg empty;
	reg [WIDTH-1:0]mem[DEPTH-1:0];
	reg wd_tgl_f;
	reg rd_tgl_f;
	reg [PTR_WIDTH-1:0]wd_ptr;
	reg [PTR_WIDTH-1:0]rd_ptr;

//write operation
	always@(posedge clk) begin
		if(rst) begin
			wr_error = 1'b0;
			wd_ptr = 1'b0;
			full = 1'b0;
			wd_tgl_f = 1'b0;
			for(i=0;i<DEPTH;i++) begin
				mem[i] = 0;
			end
		end 
		else begin
			if(wr_en) begin
				if(!full) begin
                  mem[wd_ptr] <= wdata;
					if (wd_ptr == DEPTH -1) begin
						wd_tgl_f = ~wd_tgl_f;
						wd_ptr = 1'b0;
					end
					else begin
						wd_ptr = wd_ptr + 1;
					end
                  if(full) begin
						wr_error = 1'b1;
                 end
				end
			end

		end
	end
	
//read operation
	 
	always@(posedge clk) begin
		if(rst) begin
			rd_error = 0;
			rd_ptr = 0;
			empty = 1;
			rd_tgl_f = 0;
		end 
		else begin
			if(rd_en) begin
				if(empty) begin
					rd_error = 1;
				end
				else begin
					rdata = mem[rd_ptr];
					if(rd_ptr == DEPTH-1) begin
						rd_tgl_f = ~rd_tgl_f;
						rd_ptr = 0;
					end
					else begin
						rd_ptr = rd_ptr+1;
					end
				end
			end
		end
	end

	always@(*) begin
		if(wd_ptr == rd_ptr && wd_tgl_f == rd_tgl_f) begin
			empty = 1;
		end
		else begin
			empty = 0;
		end

		if(wd_ptr == rd_ptr && wd_tgl_f != rd_tgl_f) begin
			full = 1;
		end
		else begin
			full = 0;
		end
 	end
endmodule


