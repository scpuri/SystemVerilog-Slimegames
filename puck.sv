module puck (
	input Reset, frame_clk,
	input [9:0] Actor_X, Actor_Y, Actor_Size, Jump_X, Jump_Y, Jump_Size,
	output [9:0]  BallX, BallY, BallS,
	output hit_floor, hit_target,
	output [3:0] hextotal, hextotal2,
	input Game1Screen, Game2Screen
	);

	logic [3:0] hex_score = 0;
	logic [3:0] hex_score2 = 0;

	logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ball_Size;
	 
	parameter [9:0] Ball_X_Center=200;  // Center position on the X axis
	parameter [9:0] Ball_Y_Center=100;  // Center position on the Y axis
	parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
	parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
	parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
	parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
	parameter [9:0] Ball_X_Step=7;      // Step size on the X axis
	parameter [9:0] Ball_Y_Step=7;      // Step size on the Y axis
	parameter [9:0] Ball_Ref =-10;      // Step size on the Y axis
	parameter [9:0] Ball_Bounce_neg =-15;      // Step size on the Y axis
	parameter [9:0] Ball_Bounce_pos = 10;      // Step size on the Y axis
	parameter [9:0] Gravity=5;			// Gravity acting on the ball
	logic [9:0] Ball_X_Input, Ball_Y_Input;
	logic floorhit = 0;
	logic targethit = 0;
	
	assign Ball_Size = 15;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
   
	always_ff @ (posedge Reset or posedge frame_clk )
	begin: Move_Ball
		if (Reset)  // Asynchronous Reset
		begin 
			Ball_Y_Motion <= 10'd0;
			Ball_X_Input <= 10'd0; 
			Ball_Y_Input <= 10'd0; 
			Ball_X_Motion <= 10'd0;
			Ball_Y_Pos <= Ball_Y_Center;
			Ball_X_Pos <= Ball_X_Center;
		end

		else
		begin
		/* OLD BOUNCE
//Bounce up off main slime	 
			if ( (( Ball_Y_Pos ) <= Actor_Y - Actor_Size ) && (( Ball_Y_Pos + Ball_Size ) >= ( Actor_Y - Actor_Size )) && ( Ball_X_Pos <= Actor_X + Actor_Size/3 ) && ( Ball_X_Pos >= Actor_X - Actor_Size/3 ) )
			begin
				Ball_Y_Input <= Ball_Bounce_neg; 
				Ball_X_Input <= Ball_X_Motion;
			end
	
//bounce to the right off main slime			
			else if ( (( Ball_Y_Pos ) <= Actor_Y - Actor_Size ) && (( Ball_Y_Pos + Ball_Size ) >= ( Actor_Y - Actor_Size )) && ( Ball_X_Pos > Actor_X + Actor_Size/3 ) && ( Ball_X_Pos - Ball_Size < Actor_X + Actor_Size ) )
			begin
				Ball_Y_Input <= Ball_Bounce_neg;
				Ball_X_Input <= Ball_Bounce_pos;
			end
			
//Bounce to the left off main slime	 
			else if ( (( Ball_Y_Pos ) <= Actor_Y - Actor_Size) && (( Ball_Y_Pos + Ball_Size ) >= ( Actor_Y - Actor_Size )) && ( Ball_X_Pos < Actor_X - Actor_Size/3 ) && ( Ball_X_Pos + Ball_Size > Actor_X - Actor_Size ) )
			begin
				Ball_Y_Input <= Ball_Bounce_neg;
				Ball_X_Input <= Ball_Ref;
			end
			*/
			
///===================================PLAYER================================================

			/* NEW BOUNCE */
			//LEFT
			if ( (( Ball_Y_Pos ) <= Actor_Y - Actor_Size ) && (( Ball_Y_Pos + Ball_Size ) >= ( Actor_Y - Actor_Size )) && ( Ball_X_Pos + Ball_Size > Actor_X - Actor_Size ) && ( Ball_X_Pos < Actor_X - 4 * Actor_Size/5 ) )
			begin //1
				Ball_Y_Input <= -6; 
				Ball_X_Input <= -11;
			end
			
			else if ( (( Ball_Y_Pos ) <= Actor_Y - Actor_Size ) && (( Ball_Y_Pos + Ball_Size ) >= ( Actor_Y - Actor_Size )) && ( Ball_X_Pos >= Actor_X - 4 * Actor_Size/5 ) && ( Ball_X_Pos <= Actor_X - 3 * Actor_Size/5 ) )
			begin //2
				Ball_Y_Input <= -8; 
				Ball_X_Input <= -10;
			end
			
			else if ( (( Ball_Y_Pos ) <= Actor_Y - Actor_Size ) && (( Ball_Y_Pos + Ball_Size ) >= ( Actor_Y - Actor_Size )) && ( Ball_X_Pos >= Actor_X - 3 * Actor_Size/5 ) && ( Ball_X_Pos < Actor_X - 2 * Actor_Size/5 ) )
			begin //3
				Ball_Y_Input <= -10; 
				Ball_X_Input <= -8;
			end
			
			else if ( (( Ball_Y_Pos ) <= Actor_Y - Actor_Size ) && (( Ball_Y_Pos + Ball_Size ) >= ( Actor_Y - Actor_Size )) && ( Ball_X_Pos >= Actor_X - 2 * Actor_Size/5 ) && ( Ball_X_Pos < Actor_X - 1 * Actor_Size/5 ) )
			begin //4
				Ball_Y_Input <= -13; 
				Ball_X_Input <= -1;
			end
			
			/* middle begin */
			else if ( (( Ball_Y_Pos ) <= Actor_Y - Actor_Size ) && (( Ball_Y_Pos + Ball_Size ) >= ( Actor_Y - Actor_Size )) && ( Ball_X_Pos >= Actor_X - 1 * Actor_Size/5 ) && ( Ball_X_Pos < Actor_X ) )
			begin  
				Ball_Y_Input <= Ball_Bounce_neg; 
				Ball_X_Input <= Ball_X_Motion;
			end
			
			else if ( (( Ball_Y_Pos ) <= Actor_Y - Actor_Size ) && (( Ball_Y_Pos + Ball_Size ) >= ( Actor_Y - Actor_Size )) && ( Ball_X_Pos >= Actor_X ) && ( Ball_X_Pos < Actor_X + 1 * Actor_Size/5 ) )
			begin
				Ball_Y_Input <= Ball_Bounce_neg; 
				Ball_X_Input <= Ball_X_Motion;
			end
			/* end middle */
			//RIGHT
			else if ( (( Ball_Y_Pos ) <= Actor_Y - Actor_Size ) && (( Ball_Y_Pos + Ball_Size ) >= ( Actor_Y - Actor_Size )) && ( Ball_X_Pos >= Actor_X + 1 * Actor_Size/5 ) && ( Ball_X_Pos < Actor_X + 2 * Actor_Size/5 ) )
			begin  //5
				Ball_Y_Input <= -13; 
				Ball_X_Input <= 1;
			end
			
			else if ( (( Ball_Y_Pos ) <= Actor_Y - Actor_Size ) && (( Ball_Y_Pos + Ball_Size ) >= ( Actor_Y - Actor_Size )) && ( Ball_X_Pos >= Actor_X + 2 * Actor_Size/5 ) && ( Ball_X_Pos < Actor_X + 3 * Actor_Size/5 ) )
			begin  //6
				Ball_Y_Input <= -10; 
				Ball_X_Input <= 8;
			end
			
			else if ( (( Ball_Y_Pos ) <= Actor_Y - Actor_Size ) && (( Ball_Y_Pos + Ball_Size ) >= ( Actor_Y - Actor_Size )) && ( Ball_X_Pos >= Actor_X + 3 * Actor_Size/5 ) && ( Ball_X_Pos <= Actor_X + 4 * Actor_Size/5 ) )
			begin  //7
				Ball_Y_Input <= -8; 
				Ball_X_Input <= 10;
			end
			
			else if ( (( Ball_Y_Pos ) <= Actor_Y - Actor_Size ) && (( Ball_Y_Pos + Ball_Size ) >= ( Actor_Y - Actor_Size )) && ( Ball_X_Pos > Actor_X + 4 * Actor_Size/5 ) && ( Ball_X_Pos - Ball_Size < Actor_X + Actor_Size ) )
			begin  //8
				Ball_Y_Input <= -6; 
				Ball_X_Input <= 11;
			end
			
///===================================BLOCKER================================================
			/* NEW BOUNCE */
			//LEFT
			if ( (( Ball_Y_Pos ) <= Jump_Y - Jump_Size ) && (( Ball_Y_Pos + Ball_Size ) >= ( Jump_Y - Jump_Size )) && ( Ball_X_Pos + Ball_Size > Jump_X - Jump_Size ) && ( Ball_X_Pos < Jump_X - 4 * Jump_Size/5 ) )
			begin //1
				Ball_Y_Input <= -6; 
				Ball_X_Input <= -25;
			end
			
			else if ( (( Ball_Y_Pos ) <= Jump_Y - Jump_Size ) && (( Ball_Y_Pos + Ball_Size ) >= ( Jump_Y - Jump_Size )) && ( Ball_X_Pos >= Jump_X - 4 * Jump_Size/5 ) && ( Ball_X_Pos <= Jump_X - 3 * Jump_Size/5 ) )
			begin //2
				Ball_Y_Input <= -8; 
				Ball_X_Input <= -20;
			end
			
			else if ( (( Ball_Y_Pos ) <= Jump_Y - Jump_Size ) && (( Ball_Y_Pos + Ball_Size ) >= ( Jump_Y - Jump_Size )) && ( Ball_X_Pos >= Jump_X - 3 * Jump_Size/5 ) && ( Ball_X_Pos < Jump_X - 2 * Jump_Size/5 ) )
			begin //3
				Ball_Y_Input <= -10; 
				Ball_X_Input <= -16;
			end
			
			else if ( (( Ball_Y_Pos ) <= Jump_Y - Jump_Size ) && (( Ball_Y_Pos + Ball_Size ) >= ( Jump_Y - Jump_Size )) && ( Ball_X_Pos >= Jump_X - 2 * Jump_Size/5 ) && ( Ball_X_Pos < Jump_X - 1 * Jump_Size/5 ) )
			begin //4
				Ball_Y_Input <= -13; 
				Ball_X_Input <= -13;
			end
			
			/* middle begin */
			else if ( (( Ball_Y_Pos ) <= Jump_Y - Jump_Size ) && (( Ball_Y_Pos + Ball_Size ) >= ( Jump_Y - Jump_Size )) && ( Ball_X_Pos >= Jump_X - 1 * Jump_Size/5 ) && ( Ball_X_Pos < Jump_X ) )
			begin  
				Ball_Y_Input <= Ball_Bounce_neg; 
				Ball_X_Input <= -12;
			end
			
			else if ( (( Ball_Y_Pos ) <= Jump_Y - Jump_Size ) && (( Ball_Y_Pos + Ball_Size ) >= ( Jump_Y - Jump_Size )) && ( Ball_X_Pos >= Jump_X ) && ( Ball_X_Pos < Jump_X + 1 * Jump_Size/5 ) )
			begin
				Ball_Y_Input <= Ball_Bounce_neg; 
				Ball_X_Input <= -12;
			end
			/* end middle */
			//RIGHT
			else if ( (( Ball_Y_Pos ) <= Jump_Y - Jump_Size ) && (( Ball_Y_Pos + Ball_Size ) >= ( Jump_Y - Jump_Size )) && ( Ball_X_Pos >= Jump_X + 1 * Jump_Size/5 ) && ( Ball_X_Pos < Jump_X + 2 * Jump_Size/5 ) )
			begin  //5
				Ball_Y_Input <= -13; 
				Ball_X_Input <= -11;
			end
			
			else if ( (( Ball_Y_Pos ) <= Jump_Y - Jump_Size ) && (( Ball_Y_Pos + Ball_Size ) >= ( Jump_Y - Jump_Size )) && ( Ball_X_Pos >= Jump_X + 2 * Jump_Size/5 ) && ( Ball_X_Pos < Jump_X + 3 * Jump_Size/5 ) )
			begin  //6
				Ball_Y_Input <= -10; 
				Ball_X_Input <= -13;
			end
			
			else if ( (( Ball_Y_Pos ) <= Jump_Y - Jump_Size ) && (( Ball_Y_Pos + Ball_Size ) >= ( Jump_Y - Jump_Size )) && ( Ball_X_Pos >= Jump_X + 3 * Jump_Size/5 ) && ( Ball_X_Pos <= Jump_X + 4 * Jump_Size/5 ) )
			begin  //7
				Ball_Y_Input <= -8; 
				Ball_X_Input <= -16;
			end
			
			else if ( (( Ball_Y_Pos ) <= Jump_Y - Jump_Size ) && (( Ball_Y_Pos + Ball_Size ) >= ( Jump_Y - Jump_Size )) && ( Ball_X_Pos > Jump_X + 4 * Jump_Size/5 ) && ( Ball_X_Pos - Ball_Size < Jump_X + Jump_Size ) )
			begin  //8
				Ball_Y_Input <= -6; 
				Ball_X_Input <= -20;
			end

//=====================================BOUNCES===============================================
//top wall bounce
			else if(((Ball_Y_Pos - Ball_Size ) <= Ball_Y_Min + 20))
			begin
					Ball_X_Motion <= Ball_X_Motion + Ball_X_Input;
					Ball_Y_Motion <= Ball_Y_Step; 
					Ball_X_Input <= 10'd0; 
					Ball_Y_Input <= 10'd0; 
			end			
			
//right wall bounce
			else if ( ((Ball_X_Pos + Ball_Size + Ball_X_Motion) >= Ball_X_Max) )
			begin
					Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1);  // 2's complement.	
					Ball_Y_Motion <= Ball_Y_Motion + Ball_Y_Input; 
					Ball_X_Input <= 10'd0; 
					Ball_Y_Input <= 10'd0; 
			end
				 
//left wall bounce
			else if(((Ball_X_Pos - Ball_Size ) <= Ball_X_Min + 20))
			begin
					Ball_X_Motion <= Ball_X_Step;
					Ball_Y_Motion <= Ball_Y_Motion + Ball_Y_Input;
					Ball_X_Input <= 10'd0; 
					Ball_Y_Input <= 10'd0; 
			end
	
//output if ball hits floor
			else if (Ball_Y_Pos >= Ball_Y_Max)
			begin
					floorhit = 1;
			end
			
//CHECK IF SCORES		
			else if(Ball_Y_Pos <= 206 &&  Ball_Y_Pos >= 201 && Ball_X_Pos <= 628 &&  Ball_X_Pos >= 513 )
			begin
				//targethit = 1;
					hex_score= hex_score + 1;
					hex_score2= hex_score2;
					if(hex_score >= 'd10)
					begin
						hex_score = 0;
						hex_score2 = hex_score2 + 1;
					end
					floorhit = 1;
			end
		
//GRAVITY
			if((Ball_Y_Max > Ball_Y_Pos) )//&& Ball_Y_Motion < 11 )  //in the air
						Ball_Y_Motion <= Gravity; 
			else
						Ball_Y_Motion <= Ball_Y_Motion;

		if(floorhit)
		begin
			Ball_X_Input <= 10'd0; 
			Ball_Y_Input <= 10'd0; 
			Ball_Y_Pos <= Ball_Y_Center;
			Ball_X_Pos <= Ball_X_Center;
			Ball_Y_Motion <= 0;
			Ball_X_Motion <= 0;
			floorhit = 0;
		end

		else
		begin
			Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion + Ball_Y_Input);  // Update ball position
			Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion + Ball_X_Input);
		end
			
	end  
	end	
	
	assign hextotal = hex_score;
	assign hextotal2 = hex_score2;
	assign hit_floor = floorhit;
	assign hit_target = targethit;
	assign BallX = Ball_X_Pos;
	assign BallY = Ball_Y_Pos;
	assign BallS = Ball_Size;

endmodule
