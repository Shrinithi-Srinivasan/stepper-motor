module motor_control (//1. Module Declaration and Input/Output Ports
    input clk,//clock
    input rst,//reset
  input [7:0] speed_dc,//determines the speed of dc motor
    input dir_dc,//determines the direction of dc motor
  input [1:0] dir_stepper,//determines the direction of stepper motor
    output reg pwm_dc,//pwm for controlling dc motor speed
  output reg [3:0] step_out//control stepper motor,represent state of motor's coil
);
  reg [7:0] counter_dc;//8 bit reg to count & generate the pwm signal
    always @(posedge clk or posedge rst) begin//2. PWM Generation
      if (rst) begin//reset=high
            counter_dc <= 8'd0;
            pwm_dc <= 0;
        end else begin
            counter_dc <= counter_dc + 1;//on each clk cycle ++
          if (counter_dc < speed_dc)//generates pwmbased on speed_dc
                pwm_dc <= 1;//high//on
            else
                pwm_dc <= 0;//low//off
        end
    end
  reg [1:0] step_state;//2 bit reg used to track the current step in sequence
    always @(posedge clk or posedge rst) begin//3. Stepper Motor Control Logic
      if (rst) begin//high
            step_state <= 2'b00;
            step_out <= 4'b0000;//set to inactive state
        end else begin
            case (dir_stepper)
                2'b00: step_out <= 4'b0000;//idle
                2'b01: begin//clockwise//steps forward
                    case (step_state)
                        2'b00: step_out <= 4'b1001;//p1
                        2'b01: step_out <= 4'b1010;//p2
                        2'b10: step_out <= 4'b0110;//p3
                        2'b11: step_out <= 4'b0101;//p4
                    endcase
                    step_state <= step_state + 1;
                end
                2'b10: begin//counter clockwise//steps backward
                    case (step_state)
                        2'b00: step_out <= 4'b0101;//p1
                        2'b01: step_out <= 4'b0110;//p2
                        2'b10: step_out <= 4'b1010;//p3
                        2'b11: step_out <= 4'b1001;//p4
                    endcase
                    step_state <= step_state + 1;
                end
                default: step_out <= 4'b0000;//idle
            endcase
        end
    end
endmodule
