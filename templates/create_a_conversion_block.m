% Create a new Simulink model
new_system('myModel')
open_system('myModel')

% Add a 'Constant' block to the model
add_block('simulink/Sources/Constant', 'myModel/Constant')

% Set the Constant value to a vector of four fixdt(1,4,1)
set_param('myModel/Constant', 'Value', 'fi([1 0 1 0], 1, 4, 1)')

% Add a 'Data Type Conversion' block to the model
add_block('simulink/Signal Attributes/Data Type Conversion', 'myModel/Data Type Conversion')

% Set the output data type to ufix1(16)
set_param('myModel/Data Type Conversion', 'OutDataTypeStr', 'ufix1(16)')

% Connect the 'Constant' block to the 'Data Type Conversion' block
add_line('myModel', 'Constant/1', 'Data Type Conversion/1')

% Save and close the model
save_system('myModel')
% close_system('myModel')
