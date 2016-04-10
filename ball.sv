module  slime1 ( input Reset, frame_clk,
		input [15:0] key,
               output [9:0]  BallX, BallY, BallS );
    
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ball_Size;
	 logic [9:0] Ball_X_Input, Ball_Y_Input;
	 
    parameter [9:0] Ball_X_Center=200;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=479;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=5;      // Step size on the X axis
	 parameter [9:0] Ball_Neg_Step=-5;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=8;      // Step size on the Y axis
	// parameter [9:0] Ball_Y_Jump=-200;      // Step size on the Y axis
	 parameter [9:0] Ball_Y_Jump=-15;      // Step size on the Y axis

    assign Ball_Size = 50;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Ball
        if (Reset)  // Asynchronous Reset
        begin 
            Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
				Ball_Y_Input <= 10'd0; 
				Ball_X_Motion <= 10'd0; //Ball_X_Step;
				Ball_X_Input <= 10'd0; 
				Ball_Y_Pos <= Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center;
        end
        
			else
			begin 
				 case (key)
						16'h0000: //no movement
							begin
								Ball_Y_Input <= 10'd0;
								Ball_Y_Motion <= 10'd0;
								Ball_X_Motion <= 10'd0;
								Ball_X_Input <= 10'd0;
							end
						16'h0051: //no movement
							begin
								Ball_Y_Input <= 10'd0;
								Ball_Y_Motion <= 10'd0;
								Ball_X_Motion <= 10'd0;
								Ball_X_Input <= 10'd0;
							end
						16'h0050: //left
							begin    
									Ball_X_Input <= Ball_Neg_Step;
									Ball_Y_Input <= 10'd0;

							end
						16'h004f: //right
							begin        
									Ball_X_Input <= Ball_X_Step;
									Ball_Y_Input <= 10'd0;
							end
						16'h0052: //up
							begin
									Ball_Y_Input <= Ball_Y_Jump;
							end
						/*	
						16'h524f: //up-right
							begin
								Ball_X_Input <= Ball_X_Step;
								Ball_Y_Input <= Ball_Y_Jump;
							end
						16'h4f52: //up-right 2
							begin
								Ball_X_Input <= Ball_X_Step;
								Ball_Y_Input <= Ball_Y_Jump;
							end
						16'h504f: //up left
							begin
								Ball_Y_Input <= Ball_Y_Jump;
								Ball_X_Input <= Ball_Neg_Step;
							end
						16'h4f50: //up left 2
							begin
								Ball_Y_Input <= Ball_Y_Jump;
								Ball_X_Input <= Ball_Neg_Step;
							end
							*/
				endcase

				if((Ball_Y_Max > Ball_Y_Pos))  //in the air
					begin
						Ball_Y_Motion <= Ball_Y_Step; 
						//Ball_Y_Input <= 0;
					end
					
				//right side
				if((Ball_X_Pos + Ball_Size ) >= Ball_X_Max - 200)
					begin
						Ball_X_Motion <= Ball_Neg_Step;  
					end
					
				//left side
				if(((Ball_X_Pos - Ball_Size) <= Ball_X_Min))
					begin
						Ball_X_Motion <= Ball_X_Step;
						Ball_X_Input <= Ball_X_Step;
					end
				
				if ( ((Ball_Y_Pos ) >= Ball_Y_Max - 10) )
				begin
						Ball_Y_Pos <= Ball_Y_Min;
						Ball_Y_Motion <= 10'd0;
				end
				
				if ( ((Ball_Y_Pos - Ball_Size) <= Ball_Y_Min + 10) )
					begin
						Ball_Y_Motion <= Ball_Y_Step;
						Ball_Y_Input <= 10'd0;
					end
/*
				if ( ((Ball_Y_Pos + Ball_Size) >= Ball_Y_Max) )
				 begin
						Ball_Y_Motion <= (~ (Ball_Y_Step) + 1'b1);  // 2's complement.	
						Ball_X_Motion <= 10'd0;
				 end
				 else if(((Ball_Y_Pos - Ball_Size) <= Ball_Y_Min))
				 begin
					   Ball_Y_Motion <= Ball_Y_Step;
						Ball_X_Motion <= 10'd0;
				 end
				 if ( ((Ball_X_Pos + Ball_Size) >= Ball_X_Max) )
				 begin
						Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1);  // 2's complement.	
						Ball_Y_Motion <= 10'd0;
				 end
				 else if(((Ball_X_Pos - Ball_Size) <= Ball_X_Min))
				 begin
					   Ball_X_Motion <= Ball_X_Step;
						Ball_Y_Motion <= 10'd0;
				 end
*/
				
				Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion + Ball_Y_Input);  // Update ball position
					
				Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion + Ball_X_Input);


		end  
    end
       
    assign BallX = Ball_X_Pos;
   
    assign BallY = Ball_Y_Pos;
   
    assign BallS = Ball_Size;
    

endmodule

