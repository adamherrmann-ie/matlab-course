

parent_system = 'template_examples/ex21_bit_reworking';

% Loop to create 64 Selector blocks
for i = 1:64
    % Define the block name
    block_name = ['Selector', num2str(i)];
    
    % Add the Selector block to the system
    add_block('simulink/Signal Routing/Selector', [parent_system '/' block_name]);
    
    % Set the index vector for the Selector block
    set_param([parent_system '/' block_name], 'IndexOptions', 'Select all');
    set_param([parent_system '/' block_name], 'Indices', num2str(i));
end