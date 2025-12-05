% Example call
% create_examples_systemverilog('template_examples/ex0_multiplexer'                   , '' , 'systemverilog','ex0_')
% create_examples_systemverilog('template_examples/ex1_data_enabled_ff'             , '' , 'systemverilog','ex1_')
% create_examples_systemverilog('template_examples/ex1a_data_enabled_ff'             , '' , 'systemverilog','ex1a_')
% create_examples_systemverilog('template_examples/ex1b_data_enabled_ff'             , '' , 'systemverilog','ex1b_')
% create_examples_systemverilog('template_examples/ex2_selector_8_from_24'          , '' , 'systemverilog','ex2_')
% create_examples_systemverilog('template_examples/ex3_vector_concatenation'        , '' , 'systemverilog','ex3_')
% create_examples_systemverilog('template_examples/ex4_unpacked_to_packed'          , '' , 'systemverilog','ex4_')
% create_examples_systemverilog('template_examples/ex5_partial_vector_selection'    , '' , 'systemverilog','ex5_')
% create_examples_systemverilog('template_examples/ex6_uneven_bit_concat'           , '' , 'systemverilog','ex6_')
% create_examples_systemverilog('template_examples/ex7_partial_bit_select'          , '' , 'systemverilog','ex7_')
% create_examples_systemverilog('template_examples/ex8_demux'                       , '' , 'systemverilog','ex8_')
% create_examples_systemverilog('template_examples/ex9_multiport_switch'            , '' , 'systemverilog','ex9_')
% create_examples_systemverilog('template_examples/ex10_relational_operator'        , '' , 'systemverilog','ex10_')
% create_examples_systemverilog('template_examples/ex11_fsms'                       , '' , 'systemverilog','ex11_')
% create_examples_systemverilog('template_examples/ex12_counter'                    , '' , 'systemverilog','ex12_')
% create_examples_systemverilog('template_examples/ex13_data_enabled_register'      , '' , 'systemverilog','ex13_')
% create_examples_systemverilog('template_examples/ex14_bits_and_channels'          , '' , 'systemverilog','ex14_')
% create_examples_systemverilog('template_examples/ex15_scalar_mux'                 , '' , 'systemverilog','ex15_')
% create_examples_systemverilog('template_examples/ex16_vector_mux'                 , '' , 'systemverilog','ex16_')
% create_examples_systemverilog('template_examples/ex17_vector_mux_and_scalar_ctrl' , '' , 'systemverilog','ex17_')
% create_examples_systemverilog('template_examples/ex18_vectors_to_scalars'         , '' , 'systemverilog','ex18_')
% create_examples_systemverilog('template_examples/ex19_scalars_to_vectors'         , '' , 'systemverilog','ex19_')
% create_examples_systemverilog('template_examples/ex20_cs_phase_error_angle'       , '' , 'systemverilog','ex20_')
% create_examples_systemverilog('template_examples/ex22_reference_subsystem'       , '' , 'systemverilog','ex20_')
% create_examples_systemverilog('template_examples/ex21_convert_signed_to_ufix_to_signed'       , '' , 'systemverilog','ex21_')


function create_examples_systemverilog(block_name,target_hdl_directory,myfavouritelanguage,moduleprefix)


% Get the current date as a string
dateStr = datestr(now, 'yyyymmdd');

% Create the full directory name
dirName = ['x_deframer_' dateStr];

% Check if the directory already exists
if exist(dirName, 'dir')
    % If it does, increment the directory name
    i = 1;
    while exist([dirName '.' num2str(i)], 'dir')
        i = i + 1;
    end
    dirName = [dirName '.' num2str(i)];
end

if isempty(target_hdl_directory)
target_hdl_directory = dirName;
end

block_name_for_sv_export = get_param(block_name,'Name');

disp(block_name)


makehdl(block_name_for_sv_export, ...
    'targetlanguage',myfavouritelanguage,...              % https://uk.mathworks.com/help/hdlcoder/ug/target.html#buiuh3k-20
    'Traceability','on',...                           % https://uk.mathworks.com/help/hdlcoder/ug/code-generation-report-parameters.html#buiuh3k-40
    'PreserveDesignDelays','on',...                   % https://uk.mathworks.com/help/hdlcoder/ug/pipelining-parameters.html#bu_om9f-1
    'ResourceReport','on',...                         % https://uk.mathworks.com/help/hdlcoder/ug/code-generation-report-parameters.html#buiuh3k-42
    'DeleteUnusedPorts','off',...                     % https://uk.mathworks.com/help/hdlcoder/ug/general-optimization-parameters.html#mw_f7b18e22-cd9f-459b-9db9-7a076aa75a2d
    'OptimizationReport','on',...                     % https://uk.mathworks.com/help/hdlcoder/ug/code-generation-report-parameters.html#buiuh3k-44
    'ResetType','Asynchronous',...                    % https://uk.mathworks.com/help/hdlcoder/ug/reset-and-clock-enable-settings.html#buiuh3k-60
    'ResetAssertedLevel','active-low',...             % https://uk.mathworks.com/help/hdlcoder/ug/reset-and-clock-enable-settings.html#buiuh3k-62
    'ClockInputPort','clk',...         % https://uk.mathworks.com/help/hdlcoder/ug/clock-and-timing-controller-settings.html#buiuh3k-64
    'ClockInputs','Single',...                        % https://uk.mathworks.com/help/hdlcoder/ug/clock-and-timing-controller-settings.html#buiuh3k-78
    'ClockEnableInputPort','clk_enable',...           % https://uk.mathworks.com/help/hdlcoder/ug/clock-enable-settings.html#buiuh3k-68
    'MinimizeClockEnables','on',...                   % https://uk.mathworks.com/help/hdlcoder/ug/minimize-clock-enables-and-reset-signals.html
    'ResetInputPort','rstn',...                     % https://uk.mathworks.com/help/hdlcoder/ug/reset-and-clock-enable-settings.html#buiuh3k-73
    'UserComment','(c) Intel',...                     % https://uk.mathworks.com/help/hdlcoder/ug/comment-in-header.html
    'BlockGenerateLabel','_gen',...                   % https://uk.mathworks.com/help/hdlcoder/ug/generate-statements-labels.html#mw_53c144bf-ca0b-4336-a223-4726c5b26dfb
    'InstanceGenerateLabel','_gen',...                % https://uk.mathworks.com/help/hdlcoder/ug/generate-statements-labels.html#mw_54959ae3-fe60-42c4-bae8-5e6f76f24f44
    'InstancePostfix','',...                          % https://uk.mathworks.com/help/hdlcoder/ug/generate-statements-labels.html#mw_9d7a2ae6-6c81-46a4-8e68-ec763336396b
    'ModulePrefix',moduleprefix,...                   % https://uk.mathworks.com/help/hdlcoder/ref/makehdl.html (search for moduleprefix)
    'InstancePrefix','u_',...                         % https://uk.mathworks.com/help/hdlcoder/ug/generate-statements-labels.html#mw_943198bc-ed5a-4cc6-884b-398c7756d1a8
    'VectorPrefix','vec_',...                         % https://uk.mathworks.com/help/hdlcoder/ug/generate-statements-labels.html#mw_d78e159b-8559-4ab2-ac4a-714fa92dfdad
    'UseAggregatesForConst','off',...                 % https://uk.mathworks.com/help/hdlcoder/ug/rtl-customizations-for-constants-and-matlab-function-blocks.html#buiuh3k-192
    'InitializeBlockRAM','on',...                     % https://uk.mathworks.com/help/hdlcoder/ug/rtl-customizations-for-rams.html#buiuh3k-217
    'RAMArchitecture','WithClockEnable',...           % https://uk.mathworks.com/help/hdlcoder/ug/rtl-customizations-for-rams.html#buiuh3k-219
    'NoResetInitializationMode','None',...            % https://uk.mathworks.com/help/hdlcoder/ug/no-reset-registers-initialization.html
    'MinimizeIntermediateSignals','off',...           % https://uk.mathworks.com/help/hdlcoder/ug/rtl-style.html#buiuh3k-209
    'MaskParameterAsGeneric','on',...                 % https://uk.mathworks.com/help/hdlcoder/ug/rtl-style.html#buiuh3k-215
    'SafeZeroConcat','on',...                         % https://uk.mathworks.com/help/hdlcoder/ug/rtl-annotations.html#buiuh3k-203
    'CustomFileHeaderComment','',...                  % https://uk.mathworks.com/help/hdlcoder/ug/file-comment-customization.html#mw_17fc13e9-9712-4bb2-a001-7597e41e7a1f
    'DateComment','on',...                            % https://uk.mathworks.com/help/hdlcoder/ug/rtl-annotations.html
    'RequirementComments','on',...                    % https://uk.mathworks.com/help/hdlcoder/ug/file-comment-customization.html#buiuh3k-211
    'GenerateValidationModel','on',...                % https://uk.mathworks.com/help/hdlcoder/ug/model-generation-for-hdl-code.html#buiuh3k-35
    'LayoutStyle','AutoArrange',...                   % https://uk.mathworks.com/help/hdlcoder/ug/naming-options.html#mw_78d763a5-1a29-46a4-8d3c-910004fd81eb
    'AutoRoute','on',...                              % https://uk.mathworks.com/help/hdlcoder/ug/naming-options.html#mw_8a49f8bf-5fe2-4314-86c2-e02fdeeb1d4c
    'HighlightFeedbackLoops','on',...                 % https://uk.mathworks.com/help/hdlcoder/ug/diagnostics-for-optimizations.html#buiuh3k-256
    'CodeGenerationOutput','GenerateHDLCode',...      % https://uk.mathworks.com/help/hdlcoder/ug/code-generation-output.html
    'GenerateHDLCode','on',...                        % https://uk.mathworks.com/help/hdlcoder/ug/code-generation-output.html
    'TargetDirectory',target_hdl_directory...         % https://uk.mathworks.com/help/hdlcoder/ug/target.html#buiuh3k-25
    )
end
