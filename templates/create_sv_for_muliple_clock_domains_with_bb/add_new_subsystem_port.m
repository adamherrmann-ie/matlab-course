function [below_subsystem_new_port_port_number,above_subsystem_ports,below_subsystem_new_port_port_handle,below_ss_port_name] = add_new_subsystem_port(subsystem_name,port_name)
% %UNTITLED Summary of this function goes here
% %   To connect to this port at the block level, use above_subsystem_ports.Inport(str2num(below_subsystem_new_port_port_number))
% %   To connect to this port at the subsystem level, use below_subsystem_new_port_port_handle.Outport(1)
% %   To delete this input port use delete_block(below_ss_port_name)

ss_handle = get_param(subsystem_name, 'Handle');
below_ss_port_name =  [subsystem_name '/' port_name];

%% Create new port
below_subsystem_new_port_block_handle = add_block('built-in/Inport', below_ss_port_name)
set_param(below_ss_port_name, 'OutDataTypeStr', 'boolean');

below_subsystem_new_port_port_handle = get_param(below_subsystem_new_port_block_handle,'PortHandles')
below_subsystem_new_port_port_number = get_param(below_subsystem_new_port_block_handle,'Port')

above_subsystem_ports = get_param(ss_handle, 'PortHandles');
above_below_subsystem_new_port_port_handle = above_subsystem_ports.Inport(str2num(below_subsystem_new_port_port_number))
% To connect to this port at the block level, use above_subsystem_ports.Inport(str2num(below_subsystem_new_port_port_number))

disp('DONE: add_subsystem_port')
