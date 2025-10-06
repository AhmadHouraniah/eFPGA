module EDFFRQ (E, CP, CDN, D, Q);
  input E; 
  input CP; 
  input CDN;
  input D;  
  output Q;
  
  reg q_reg;

  always @ (posedge CP or negedge CDN)
    if(~CDN) begin
      q_reg <= 0;
    end else begin
      if (E) begin
        q_reg <= D;
      end else begin
        q_reg <= Q;
      end
    end  
  assign Q = q_reg;

endmodule 