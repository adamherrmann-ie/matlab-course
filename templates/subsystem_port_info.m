% function [ss_handle] = get_subsystem_port_info(subsystem_name,port_name)
% %UNTITLED Summary of this function goes here
% %   Detailed explanation goes here

%% Set up input variables
port_name = 'block1_clk';

block_name = 'subsystem1_tb/fec_top';
block_handle = get_param(block_name, 'Handle');

subsystem_name = 'subsystem1_tb/fec_top/rs_decoder';
ss_handle = get_param(subsystem_name, 'Handle');
ss_input_port_list = find_system(ss_handle, 'SearchDepth', 1, 'BlockType', 'Inport');

disp('DONE setup input variables done')

%% Create constant and terminator
terminate_block_handle = add_block('simulink/Sinks/Terminator', [subsystem_name '/terminate_' port_name]);
terminate_port_handle  = get_param(terminate_block_handle,'PortHandles');
% To connect a line to this terminator, use terminate_port_handle.Inport(1)

constant_block_handle  = add_block('simulink/Sources/Constant', [block_name '/constant_' port_name]);
constant_port_handle = get_param(constant_block_handle,'PortHandles');
% To connect a line to this constant, use constant_port_handle.Outport(1)

disp('DONE: Create constant and terminator')

%% Create new port
below_subsystem_new_port_block_handle = add_block('built-in/Inport', [subsystem_name '/' port_name])
below_subsystem_new_port_port_handle = get_param(below_subsystem_new_port_block_handle,'PortHandles')
below_subsystem_new_port_port_number = get_param(below_subsystem_new_port_block_handle,'Port')

above_subsystem_ports = get_param(ss_handle, 'PortHandles');
above_below_subsystem_new_port_port_handle = above_subsystem_ports.Inport(str2num(below_subsystem_new_port_port_number))
% To connect to this port at the block level, use above_subsystem_ports.Inport(str2num(below_subsystem_new_port_port_number))

% above_below_subsystem_new_port_port_handle = find_system(ss_handle, 'SearchDepth', 1, 'BlockType', 'Inport');

disp('DONE: Create new port')

%% Add line at subsystem Level
subsystem_line_handle = add_line(subsystem_name, below_subsystem_new_port_port_handle.Outport(1), terminate_port_handle.Inport(1));


%% Add line at block level
block__line_handle = add_line(block_name, constant_port_handle.Outport(1), above_subsystem_ports.Inport(str2num(below_subsystem_new_port_port_number)));

%% Delete constant and terminator
delete_block([subsystem_name '/terminate_' port_name])
delete_block([block_name '/constant_' port_name])
delete_block([subsystem_name '/' port_name])
delete_line(subsystem_line_handle)
delete_line(block_line_handle)
disp('DONE Delete constant and terminator')

%% Delete Line

disp('DONE Delete constant and terminator')



%% Connect from subsystem port to...
for i = 1:length(ss_input_port_list)

    ss_input_port_name = get_param(ss_input_port_list(i),'Name')
    ss_input_port_handle = get_param(ss_input_port_list(i),'Handle')
    ss_input_port_number = get_param(ss_input_port_list(i),'Port')

    add_line
    % input_port_all_parameters = get(get_param(gcb,'handle'))
    % inport_handle = subsystem_handle.Inport(1)
end

% end