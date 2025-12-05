clear

% +---------------------------------------------------------------------------------------+
% |       fec_top_tb.slx                                                                  |
% |                                                                                       |
% |                +--------------------------------------------------------------+       |
% |                | fec_top.slx                                                  |       |
% |                |                                                              |       |
% |                |                                                              |       |
% |                |                                                              |       |
% |                |          +--------------------------------------------+      |       |
% |                |          | rs_decoder.slx                             |      |       |
% |                |          |                  +--------------------+    |      |       |
% |                |          |        +---+     |rs.sv (stub)        |    |      |       |
% |                |          |        | D |     |                    |    |      |       |
% |                |          |        +---+     |                    |    |      |       |
% |                |          |                  |                    |    |      |       |
% |                |          |                  |                    |    |      |       |
% |      rs_clk---------------->                 |                    |    |      |       |
% |                |          |                  | (blackbox)         |    |      |       |
% |                |          |                  +--------------------+    |      |       |
% |                |          |                                            |      |       |
% |                |          | (rs_clk domain)                            |      |       |
% |                |          +--------------------------------------------+      |       |
% |                |                                                              |       |
% |                |          +--------------------------------------------+      |       |
% |                |          | omem.slx                                   |      |       |
% |                |          |                                            |      |       |
% |                |          |                                            |      |       |
% |                |          |                                            |      |       |
% |                |          |                                            |      |       |
% |                |          |                                            |      |       |
% |    fec_clk------>         |                                            |      |       |
% |                |          | (fec_clk domain)                           |      |       |
% |                |          +--------------------------------------------+      |       |
% |                |                                                              |       |
% |                | (fec_clk domain)                                             |       |
% |                +--------------------------------------------------------------+       |
% |                                                                                       |
% +---------------------------------------------------------------------------------------+

% 1. remove all HDLCoder parameters
% 2. convert the stub to a black box
% 3. Export the rs_clk domain systemverilog (with the correct clock)
% 4. add the clock pin (and reset pin) through the hierarchy. The new clock is added to the level of the rs_decoder (not to the level of the rs.sv stub)
% 5. convert the rs_decoder into a black box
% 6. Export fec_top with with the fec_clk clock domain. 
% 7. Remove the clock pins

%% 1. Reset all HDL parameters
hdlrestoreparams('fec_top_tb')
save_system('fec_top_tb')


%% 2. This is the blackbox for the .sv code stub
hdlset_param('fec_top_tb/fec_top/rs_decoder/rs', 'Architecture', 'BlackBox');
% Set SubSystem HDL parameters
hdlset_param('fec_top_tb/fec_top/rs_decoder/rs', 'AddClockEnablePort', 'off');
hdlset_param('fec_top_tb/fec_top/rs_decoder/rs', 'AddClockPort', 'on');
hdlset_param('fec_top_tb/fec_top/rs_decoder/rs', 'AddResetPort', 'on');
hdlset_param('fec_top_tb/fec_top/rs_decoder/rs', 'ClockInputPort', 'rs_clk');
hdlset_param('fec_top_tb/fec_top/rs_decoder/rs', 'EntityName', 'rs');
hdlset_param('fec_top_tb/fec_top/rs_decoder/rs', 'ImplementationLatency', 0);
hdlset_param('fec_top_tb/fec_top/rs_decoder/rs', 'InlineConfigurations', 'off');
hdlset_param('fec_top_tb/fec_top/rs_decoder/rs', 'ResetInputPort', 'rs_rstn');
hdlset_param('fec_top_tb/fec_top/rs_decoder/rs', 'VHDLArchitectureName', '');
hdlset_param('fec_top_tb/fec_top/rs_decoder/rs', 'VHDLComponentLibrary', '');
save_system('fec_top_tb')

%% 3. Create verilog at SS level 
template_export_sv( 'fec_top_tb/fec_top/rs_decoder','240302','systemverilog','','rs_clk','rs_rstn')

%% 4. Adding new clock port to the subsystem and block levels
port_to_be_added = 'rs_clk';
[rs_decoder_clk__below_subsystem_new_port_port_number,rs_decoder_clk__above_subsystem_ports,rs_decoder_clk__below_subsystem_new_port_port_handle,rs_decoder_clk__below_ss_port_name]     = add_new_subsystem_port('fec_top_tb/fec_top/rs_decoder',port_to_be_added);
[fec_top_clk__below_subsystem_new_port_port_number,fec_top_clk__above_subsystem_ports,fec_top_clk__below_subsystem_new_port_port_handle,fec_top_clk__below_ss_port_name]                 = add_new_subsystem_port('fec_top_tb/fec_top',port_to_be_added);
fec_top_clk__line_handle  = add_line('fec_top_tb/fec_top',fec_top_clk__below_subsystem_new_port_port_handle.Outport(1), rs_decoder_clk__above_subsystem_ports.Inport(str2num(rs_decoder_clk__below_subsystem_new_port_port_number)) );

port_to_be_added = 'rs_rstn';
[rs_decoder_rstn__below_subsystem_new_port_port_number,rs_decoder_rstn__above_subsystem_ports,rs_decoder_rstn__below_subsystem_new_port_port_handle,rs_decoder_rstn__below_ss_port_name] = add_new_subsystem_port('fec_top_tb/fec_top/rs_decoder',port_to_be_added);
[fec_top_rstn__below_subsystem_new_port_port_number,fec_top_rstn__above_subsystem_ports,fec_top_rstn__below_subsystem_new_port_port_handle,fec_top_rstn__below_ss_port_name]             = add_new_subsystem_port('fec_top_tb/fec_top',port_to_be_added);
fec_top_rstn__line_handle  = add_line('fec_top_tb/fec_top',fec_top_rstn__below_subsystem_new_port_port_handle.Outport(1), rs_decoder_rstn__above_subsystem_ports.Inport(str2num(rs_decoder_rstn__below_subsystem_new_port_port_number)) );


%% 5. Make the subsystem a black box. The subsystem in this case has both the blackbox stub and it has simulink in the dedicated clock domain
hdlset_param('fec_top_tb/fec_top/rs_decoder', 'Architecture', 'BlackBox');
% Set SubSystem HDL parameters
hdlset_param('fec_top_tb/fec_top/rs_decoder', 'AddClockEnablePort', 'off');
hdlset_param('fec_top_tb/fec_top/rs_decoder', 'AddClockPort', 'off');
hdlset_param('fec_top_tb/fec_top/rs_decoder', 'AddResetPort', 'off');
hdlset_param('fec_top_tb/fec_top/rs_decoder', 'ClockInputPort', 'rs_clk');
hdlset_param('fec_top_tb/fec_top/rs_decoder', 'EntityName', 'rs_decoder');
hdlset_param('fec_top_tb/fec_top/rs_decoder', 'ImplementationLatency', 0);
hdlset_param('fec_top_tb/fec_top/rs_decoder', 'InlineConfigurations', 'off');
hdlset_param('fec_top_tb/fec_top/rs_decoder', 'ResetInputPort', 'rs_rstn');
save_system('fec_top_tb')

%% 6. Create verilog at top level 
template_export_sv( 'fec_top_tb/fec_top','240302','systemverilog','','fec_clk','fec_rstn')

%% 7. Revert the model
delete_line(fec_top_clk__line_handle)
delete_block(rs_decoder_clk__below_ss_port_name)
delete_block(fec_top_clk__below_ss_port_name)


delete_line(fec_top_rstn__line_handle)
delete_block(rs_decoder_rstn__below_ss_port_name)
delete_block(fec_top_rstn__below_ss_port_name)
hdlrestoreparams('fec_top_tb')
save_system('fec_top_tb')
