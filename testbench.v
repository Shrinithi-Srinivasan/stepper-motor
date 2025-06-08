module tb_motor_control;
    reg clk;
    reg rst;
    reg [7:0] speed_dc;
    reg dir_dc;
    reg [1:0] dir_stepper;
    wire pwm_dc;
    wire [3:0] step_out;
    motor_control uut (
        .clk(clk),
        .rst(rst),
        .speed_dc(speed_dc),
        .dir_dc(dir_dc),
        .dir_stepper(dir_stepper),
        .pwm_dc(pwm_dc),
        .step_out(step_out)
    );
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    initial begin
        $dumpfile("dumpfile.vcd");
    	$dumpvars(1);
        rst = 1;
        speed_dc = 8'd128;
        dir_dc = 0;
        dir_stepper = 2'b00;
        #20 rst = 0;
        #50 dir_dc = 1;
        #50 speed_dc = 8'd200;
        #100 dir_stepper = 2'b01;
        #200 dir_stepper = 2'b10;
        #200 dir_stepper = 2'b00;
        #300 $finish;
    end
    initial begin
        $monitor("Time: %0d, Reset: %b, Speed DC: %d, Direction DC: %b, Stepper Direction: %b, PWM DC: %b, Stepper Output: %b", $time, rst, speed_dc, dir_dc, dir_stepper, pwm_dc, step_out);
    end
endmodule
