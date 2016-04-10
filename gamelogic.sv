module gamelogic(input Reset, frame_clk,
						input [7:0] key,
						input hit_floor, 
						input has_reset,
						input hit_target,
						output MainS,
						output StartScreen,
						output Instructions,
						output PauseScreen1,
						output PauseScreen2,
						output Game1Screen,
						output Game2Screen,
						output ExitScreen,
						output [10:0] Score,
						output [3:0] hextotal,hextotal2);
					  
enum logic [3:0] {MainScreen, Start, Instruction, Exit, Pause1, Pause2, Game1, Game2}   State, Next_state;   // Internal state logic
logic main, start, inst, pause1, pause2, game1, game2, incscore, rdy, ext;
logic nextb;
logic [10:0] score_total;
logic [3:0] hex_score, hex_score2;


  always_ff @ (posedge Reset or posedge frame_clk  )
    begin : Assign_Next_State
        if (Reset) 
            State <= MainScreen;
        else 		
            State <= Next_state;
    end	

//STATE LOGICS
	always_comb
    	begin 
	    Next_state  = State;
	 
	unique case (State)
 	MainScreen : begin
	      if (key == 8'h1e)  //1
				Next_state <= Start;
			if (key == 8'h1f)  //2
				Next_state <= Instruction;	
					end
	Start : begin
		if (key == 8'h05)  //B
			Next_state <= Game1;
		if (key == 8'h1a)  //W
			Next_state <= Game2;			
					end
	Instruction : begin
		if (key == 8'h1e)  //1
			Next_state <= Start;	
		if (key == 8'h29)  //ESC
			Next_state <= MainScreen;	
					end
	Pause1 :  begin
		if (key == 8'h15)  //R
			Next_state <= Game1;
		if (key == 8'h29)  //ESC
			Next_state <= MainScreen;
					end
	Pause2 :  begin
		if (key == 8'h15)  //R
			Next_state <= Game2;
		if (key == 8'h29)  //ESC
			Next_state <= MainScreen;	
					end
	Game1 :  begin
		if (key == 8'h13)  //P
			Next_state <= Pause1;	
					end
	Game2 :  begin
		if (key == 8'h13)  //P
			Next_state <= Pause2;	
					end
					
	endcase
end	
	

//ACTION AT EACH STATE
	always_ff @ (posedge Reset or posedge frame_clk  )
    begin 

		main = 0;
		start = 0;
		inst = 0;
		pause1 = 0;
		pause2 = 0;
		incscore = 0;
		hex_score = hex_score;
		score_total = score_total;
		hex_score2= hex_score2;

	    case (State)
			MainScreen : 
				begin 
					main = 1; 
					start = 0;
					inst = 0;
					ext = 0;
					pause1 = 0;
					pause2 = 0;
					game1 = 0; 
					game2 = 0;
					rdy = 0;

					score_total = 0;
					hex_score = 0;
					hex_score2 = 0;
					incscore = 0;
				end
			Start : 
				begin 
					main = 0; 
					start = 1;
					inst = 0;
					ext = 0;
					pause1 = 0;
					pause2 = 0;
					game1 = 0; 
					game2 = 0;
					rdy = 0;

					score_total = 0;
					hex_score = 0;
					hex_score2 = 0;
					rdy = 0;
					incscore = 0;
				end
			Instruction : 
				begin 
					main = 0; 
					start = 0;
					inst = 1;
					ext = 0;
					pause1 = 0;
					pause2 = 0;
					game1 = 0; 
					game2 = 0;
					rdy = 0;
				end
			Exit : 
				begin 
					main = 0; 
					start = 0;
					inst = 0;
					ext = 1;
					pause1 = 0;
					pause2 = 0;
					game1 = 0; 
					game2 = 0;
					rdy = 0;
				end
			Pause1 : 
				begin 
					main = 0; 
					start = 0;
					inst = 0;
					ext = 0;
					pause1 = 1;
					pause2 = 0;
					game1 = 0; 
					game2 = 0;
					rdy = 0;
				end
			Pause2 : 
				begin 
					main = 0; 
					start = 0;
					inst = 0;
					ext = 0;
					pause1 = 0;
					pause2 = 1;
					game1 = 0; 
					game2 = 0;
					rdy = 0;
				end
			Game1 : 
				begin
					main = 0; 
					start = 0;
					inst = 0;
					ext = 0;
					pause1 = 0;
					pause2 = 0;
					game1 = 1; 
					game2 = 0;
					rdy = 0;
					/*
					if(hit_target)
					begin
						score_total++;
						hex_score= hex_score + 1;
						hex_score2= hex_score2;
						if(hex_score >= 'd10)
						begin
							hex_score = 0;
							hex_score2 = hex_score2 + 1;
						end
					end
					*/
				end
			Game2 :
				begin
					main = 0; 
					start = 0;
					inst = 0;
					ext = 0;
					pause1 = 0;
					pause2 = 0;
					game1 = 0; 
					game2 = 1;
					rdy = 0;
				/*
				if(hit_target)
					begin
						score_total++;
						hex_score= hex_score + 1;
						hex_score2= hex_score2;
						if(hex_score >= 'd10)
						begin
							hex_score = 0;
							hex_score2 = hex_score2 + 1;
						end
					end
					*/
			end
		endcase
		
	end 	
		assign MainS = main;
		assign StartScreen = start;
		assign Instructions = inst;
		assign PauseScreen1 = pause1;
		assign PauseScreen2 = pause2;
		assign Game1Screen = game1;
		assign Game2Screen = game2;
		assign Ready = rdy;
		assign ExitScreen = ext;
		
		assign totalscore = score_total;
		assign hextotal = hex_score;
		assign hextotal2 = hex_score2;

	
endmodule
