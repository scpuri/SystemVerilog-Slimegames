//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( 	input        [9:0] BallX, BallY, DrawX, DrawY, Ball_size, JumpX, JumpY, JumpS, PuckX, PuckY, PuckS, WallballX, WallballY, WallballS,
			input MainS, StartScreen, Instructions, PauseScreen1, PauseScreen2, Game1Screen, Game2Screen, ExitScreen, Ready,
			input [0:95][0:171][0:1] Title,
			input [0:53][0:205][0:1] Names,
			input [0:95][0:137][0:1] InstructionTXT,
			input [0:25][0:116][0:1] MainOptions,
			input [0:25][0:98][0:1] GameSelect,
			input [0:150][0:126][0:3] Hoop,
			input [0:47][0:63][0:1] Pause,
			input [0:399][0:9][0:1] wallTXT,
         output logic [7:0]  Red, Green, Blue );
			
		logic ball_on, jump_on, puck_on, wallball_on;
		//480x640
		logic[1:0] Title_on;
		logic[9:0] Title_x = 234; //Center
		logic[9:0] Title_y = 144;
		logic[9:0] Title_size_x = 10'd172;
		logic[9:0] Title_size_y = 10'd96;
		
		logic Name_on;
		logic[9:0] Name_x = 435; //Center
		logic[9:0] Name_y = 426;
		logic[9:0] Name_size_x = 10'd205;
		logic[9:0] Name_size_y = 10'd54;
		
		logic Inst_on;
		logic[9:0] Inst_x = 251; //Center
		logic[9:0] Inst_y = 150;
		logic[9:0] Inst_size_x = 10'd138;
		logic[9:0] Inst_size_y = 10'd96;
		
		logic MainOpt_on;
		logic[9:0] MainOpt_x = 277; //Center
		logic[9:0] MainOpt_y = 340;
		logic[9:0] MainOpt_size_x = 10'd117;
		logic[9:0] MainOpt_size_y = 10'd26;
		
		logic GameSel_on;
		logic[9:0] GameSel_x = 277; //Center
		logic[9:0] GameSel_y = 200;
		logic[9:0] GameSel_size_x = 10'd99;
		logic[9:0] GameSel_size_y = 10'd26;
		
		logic wall_on;
		logic[9:0] wall_x = 630; //Center
		logic[9:0] wall_y = 80;
		logic[9:0] wall_size_x = 10'd10;
		logic[9:0] wall_size_y = 10'd400;
		
		logic[2:0] Hoop_on;
		logic[9:0] Hoop_x = 513; //Center
		logic[9:0] Hoop_y = 120;
		logic[9:0] Hoop_size_x = 10'd127;
		logic[9:0] Hoop_size_y = 10'd151;
	
		logic Pause_on;
		logic[9:0] Pause_x = 287; //Center
		logic[9:0] Pause_y = 200;
		logic[9:0] Pause_size_x = 10'd64;
		logic[9:0] Pause_size_y = 10'd48;
	  
//player1 moving slime
		int DistX, DistY, Size;
		assign DistX = DrawX - BallX;
		assign DistY = DrawY - BallY;
		assign Size = Ball_size;
	 
//player2 jumping slime
		int DistX2, DistY2, Size2;
		assign DistX2 = DrawX - JumpX;
		assign DistY2 = DrawY - JumpY;
		assign Size2 = JumpS;
		
//PUCK
		int DistX3, DistY3, Size3;
		assign DistX3 = DrawX - PuckX;
		assign DistY3 = DrawY - PuckY;
		assign Size3 = PuckS;
//Wallball
		int DistX4, DistY4, Size4;
		assign DistX4 = DrawX - WallballX;
		assign DistY4 = DrawY - WallballY;
		assign Size4 = WallballS;
		
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		always_comb
		begin:TITLE
				if(MainS && ((DrawX >= Title_x) && (DrawX <= Title_x + Title_size_x) 
					&& (DrawY >= Title_y) &&(DrawY <= Title_y +Title_size_y)))
					Title_on = Title[DrawY-Title_y][DrawX-Title_x];
				else
					Title_on = 2'b00;
		end
		
		always_comb
		begin:NAMES
				if(MainS && ((DrawX >= Name_x) && (DrawX <= Name_x + Name_size_x) 
					&& (DrawY >= Name_y) &&(DrawY <= Name_y +Name_size_y)))
					Name_on = Names[DrawY-Name_y][DrawX-Name_x];
				else
					Name_on = 1'b0;
		end
		
		always_comb
		begin:WALL
				if(Game2Screen && ((DrawX >= wall_x) && (DrawX <= wall_x + wall_size_x) 
					&& (DrawY >= wall_y) &&(DrawY <= wall_y +wall_size_y)))
					wall_on = wallTXT[DrawY-wall_y][DrawX-wall_x];
				else
					wall_on = 1'b0;
		end
		
		always_comb
		begin:HOOOOP
				if(Game1Screen && ((DrawX >= Hoop_x) && (DrawX <= Hoop_x + Hoop_size_x) 
					&& (DrawY >= Hoop_y) &&(DrawY <= Hoop_y + Hoop_size_y)))
					Hoop_on = Hoop[DrawY-Hoop_y][DrawX-Hoop_x];
				else
					Hoop_on = 3'b000;
		end
		
		
		always_comb
		begin:INSTRUCTIONS
				if(Instructions && ((DrawX >= Inst_x) && (DrawX <= Inst_x + Inst_size_x) 
					&& (DrawY >= Inst_y) &&(DrawY <= Inst_y +Inst_size_y)))
					Inst_on = InstructionTXT[DrawY-Inst_y][DrawX-Inst_x];
				else
					Inst_on = 1'b0;
		end
		
		always_comb
		begin:Mainopt
				if(MainS && ((DrawX >= MainOpt_x) && (DrawX <= MainOpt_x + MainOpt_size_x) 
					&& (DrawY >= MainOpt_y) &&(DrawY <= MainOpt_y +MainOpt_size_y)))
					MainOpt_on = MainOptions[DrawY-MainOpt_y][DrawX-MainOpt_x];
				else
					MainOpt_on = 1'b0;
		end
		
		always_comb
		begin:GameSele
				if(StartScreen && ((DrawX >= GameSel_x) && (DrawX <= GameSel_x + GameSel_size_x) 
					&& (DrawY >= GameSel_y) &&(DrawY <= GameSel_y +GameSel_size_y)))
					GameSel_on = GameSelect[DrawY-GameSel_y][DrawX-GameSel_x];
				else
					GameSel_on = 1'b0;
		end
		
		always_comb
		begin:PauseScreenn1
				if((PauseScreen1 || PauseScreen2 )&& ((DrawX >= Pause_x) && (DrawX <= Pause_x + Pause_size_x) 
					&& (DrawY >= Pause_y) &&(DrawY <= Pause_y +Pause_size_y)))
					Pause_on = Pause[DrawY-Pause_y][DrawX-Pause_x];
				else
					Pause_on = 1'b0;
		end
		
		always_comb
		begin:Ball_on
				if ((Game1Screen || Game2Screen) &&(( DistX*DistX + DistY*DistY) <= (Size * Size)) && DistY < 0 )
					ball_on = 1'b1;
				else 
					ball_on = 1'b0;
		end
		
		always_comb
		begin:Jump_on			
				if ( Game1Screen &&(( DistX2*DistX2 + DistY2*DistY2) <= (Size2 * Size2)) && DistY2 < 0 ) 
					jump_on = 1'b1;
				else 
					jump_on = 1'b0;
		end 
		
		always_comb
		begin:Puck_on			
				if ( (Game1Screen )  && (( DistX3*DistX3 + DistY3*DistY3) <= (Size3 * Size3)) ) 
					puck_on = 1'b1;
				else 
					puck_on = 1'b0;
		end 
		
		always_comb
		begin:wAallball_on			
				if ( (Game2Screen)  && (( DistX4*DistX4 + DistY4*DistY4) <= (Size4 * Size4)) ) 
					wallball_on = 1'b1;
				else 
					wallball_on = 1'b0;
		end 
		
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    always_comb
    begin:RGB_Display
		if ((puck_on == 1'b1)) 
			begin 
            Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
			end  
		
		else if ((wallball_on == 1'b1)) 
			begin 
            Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
			end  
		
		else if ((wall_on == 1'b1)) 
			begin 
            Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
			end  
			
		else if ((Hoop_on == 3'b001)) 
			begin 
            Red = 8'h00;
            Green = 8'h00;
            Blue = 8'h00;
			end  
			
		else if ((Hoop_on == 3'b010)) 
			begin 
            Red = 8'hff;
            Green = 8'h99;
            Blue = 8'h00;
			end
			
		else if ((Hoop_on == 3'b011)) 
			begin 
            Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
			end 

		else if ((Hoop_on == 3'b100)) 
			begin 
            Red = 8'hf4;
            Green = 8'ha4;
            Blue = 8'h60;
			end 

		else if ((ball_on == 1'b1)) 
			begin 
            Red = 8'h00;
            Green = 8'hff;
            Blue = 8'h00;
			end  

		else if ((jump_on == 1'b1)) 
			begin 
            Red = 8'hcc;
            Green = 8'h00;
            Blue = 8'h00;
			end  
			
		else if ((Title_on == 2'b01)) 
			begin 
            Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
			end  
		else if ((Title_on == 2'b10)) 
			begin 
            Red = 8'h00;
            Green = 8'hff;
            Blue = 8'h00;
			end  
		else if ((Title_on == 2'b11)) 
			begin 
            Red = 8'h33;
            Green = 8'h00;
            Blue = 8'h00;
			end  
			
		else if ((Name_on == 1'b1)) 
			begin 
            Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
			end 
		
		else if ((Pause_on == 1'b1)) 
			begin 
            Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
			end 
		
		else if ((Inst_on == 1'b1)) 
			begin 
            Red = 8'hcc;
            Green = 8'h00;
            Blue = 8'h00;
			end  
		else if ((MainOpt_on == 1'b1)) 
			begin 
            Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
			end  
		else if ((GameSel_on == 1'b1)) 
			begin 
            Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
			end  
		else 
			begin
					if(DrawY <= 300)
					begin
						Red = 8'h00; 
						Green = 8'hbf;
						Blue = 8'hff;
					end
				else
				begin
					Red = 8'h7f; 
					Green = 8'h8c;
					Blue = 8'h8d;
				end
		end
	end
endmodule
