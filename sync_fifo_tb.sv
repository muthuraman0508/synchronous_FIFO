
module sync_fifo_tb;
	parameter DEPTH = 16;
	parameter WIDTH = 8;
  parameter PTR_WIDTH = $clog2(DEPTH); 
	reg clk;
	reg rst;
	reg wr_en;
	reg rd_en;
	reg [WIDTH-1:0]wdata;
	wire [WIDTH-1:0]rdata;
	wire wr_error;
	wire rd_error;

	integer i;
  sync_fifo #(.WIDTH(WIDTH),.DEPTH(DEPTH)) dut (.rdata(rdata),.wdata(wdata),.clk(clk),.rst(rst),.wr_en(wr_en),.rd_en(rd_en),.wr_error(wr_error),.rd_error(rd_error));


	always #5 clk = ~clk;


	initial begin

		clk = 0;
		#5000 $finish();
	end

	initial begin
		rst = 1;
      	repeat(2)@(posedge clk);
      	//#20;
		rst = 0;
		$display("####the write and read will happened here#####");
      
      write(0,DEPTH);
      read(0,DEPTH);
   
    end


  task write(input reg [PTR_WIDTH-1:0]starting,input reg [PTR_WIDTH:0]position); begin
        $display("this is write operaton");
     $display("starting = %0d position = %0d",starting,position);
     for(i = starting;i<(starting+position);i++) begin
				@(posedge clk);
				wdata <= $urandom_range(10,50);
       			#1 wr_en <= 1;
				$display("i = %0d wdata = %0d",i,wdata);
        end
         @(posedge clk);
 		wr_en <= 0;
      end
      endtask

       task read(input reg [PTR_WIDTH - 1:0] starting,input reg [PTR_WIDTH: 0] position); begin
         $display("this is read operaton");
        for(i = starting;i<starting+position;i++) begin
          #1 rd_en = 1;
          @(posedge clk);			
			#2 $display("i = %0d rdata = %0d",i,rdata);
        end
        @(posedge clk);
		rd_en <= 0;
      end
      endtask
  initial begin
    $display("dump.vcs");
    $dumpvars();
  end
endmodule
