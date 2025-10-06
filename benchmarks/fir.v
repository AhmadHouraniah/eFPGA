module fir(
	input clk,
	input GLOBAL_RESET,
	input wire [7:0] filter_in,    
	output reg [15:0] filter_out   
    );
	
	parameter word_width = 8;  
	parameter order = 3;  // 4 taps (4 multipliers)

	// define delay unit , input width is 8  , filter order is 3
	reg [word_width-1:0] delay_pipeline[order:0];
	
	// define coef 
	wire [word_width-1:0]  coef[order:0];
	assign coef[0] = 8'd7;   // Scaled down coefficients
	assign coef[1] = 8'd23;
	assign coef[2] = 8'd23;
	assign coef[3] = 8'd7;

	// define multipler
	reg [15:0]  product[3:0];

	// define input data buffer
	reg [7:0] data_in_buf;

	// data buffer
	always @(posedge clk) begin
		if (GLOBAL_RESET) begin
			data_in_buf <= 0;
		end
		else begin
			data_in_buf <= filter_in;
		end
	end

	// delay units pipeline
	always @(posedge clk) begin
		if (GLOBAL_RESET) begin
			delay_pipeline[0] <= 0;
			delay_pipeline[1] <= 0;
			delay_pipeline[2] <= 0;
			delay_pipeline[3] <= 0;
		end 
		else begin
			delay_pipeline[0] <= data_in_buf;
			delay_pipeline[1] <= delay_pipeline[0];
			delay_pipeline[2] <= delay_pipeline[1];
			delay_pipeline[3] <= delay_pipeline[2];
		end
	end

	// implement product with coef 
	always @(posedge clk) begin
		if (GLOBAL_RESET) begin
			product[0] <= 0;
			product[1] <= 0;
			product[2] <= 0;
			product[3] <= 0;
		end
		else begin
			product[0] <= coef[0] * delay_pipeline[0];
			product[1] <= coef[1] * delay_pipeline[1];
			product[2] <= coef[2] * delay_pipeline[2];
			product[3] <= coef[3] * delay_pipeline[3];
		end
	end

	// accumulation
	always @(posedge clk) begin
		if (GLOBAL_RESET) begin
			filter_out <= 0;
		end
		else begin
			filter_out <= product[0] + product[1] + product[2] + product[3];
		end
	end


endmodule
