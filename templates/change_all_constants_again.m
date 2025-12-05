% Get the current system
current_system = gcs;

% Find all Constant blocks in the current system
constant_blocks = find_system(current_system, 'BlockType', 'Constant');

% Loop through each Constant block
for i = 1:length(constant_blocks)
    % Get the handle of the current Constant block
    block_handle = get_param(constant_blocks{i}, 'Handle');
    
    % Get the current value of the Constant block
    current_value = get_param(block_handle, 'Value');
    
    isPrintable = (current_value >= 32 & current_value <= 126) | current_value == 9 | current_value == 10 | current_value == 13;

    % Use the logical vector to index into the original string
    str = current_value(isPrintable);
    
    % Regular expression pattern
    pattern = 'storedInteger.csr\.(\w+).';

    % Replacement string
    replaceStr = 'csr.$1';

    % Use regexprep to replace
    newStr = regexprep(str, pattern, replaceStr)

    % Set the new value to the Constant block
    set_param(block_handle, 'Value', newStr);
end
