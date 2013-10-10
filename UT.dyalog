:NameSpace UT

sac ← 0
expect ← ⍬
exception ← ⍬
nexpect ← ⍬

∇ {Z} ← {Conf} run Argument;PRE_test;POST_test;TEST_step;COVER_step;FromSpace

  load_display_if_not_already_loaded
  load_salt_scripts_into_current_namespace_if_configured

  FromSpace ← 1 ⊃ ⎕RSI

  PRE_test ← {}
  POST_test ← {}
  COVER_step ← {} 
  :If 0 ≠ ⎕NC 'Conf'
          :if Conf has 'cover_target'
                  PRE_test ← { {} ⎕PROFILE 'start' }                        
                  POST_test ← { {} ⎕PROFILE 'stop' }
          :endif
  :EndIf

  :If is_function Argument
          TEST_step ← single_function_test_function
          COVER_file ← Argument,'_coverage.html'
          
  :ElseIf is_list_of_functions Argument
          TEST_step ← list_of_functions_test_function
          COVER_file ← 'list_coverage.html'
          
  :ElseIf is_file Argument
          TEST_step ← file_test_function
          COVER_file ← (get_file_name Argument),'_coverage.html'
          
  :ElseIf is_dir Argument
          test_files ← test_files_in_dir Argument
          TEST_step ← test_dir_function
          Argument ← test_files
  :EndIf

  :If 0 ≠ ⎕NC 'Conf'
          :if  Conf has 'cover_target'
                  COVER_step ← { Conf ,← ⊂('cover_file' COVER_file)  
                                 generate_coverage_page Conf }
          :endif
  :EndIf

  PRE_test ⍬
  Z ← FromSpace TEST_step Argument
  POST_test ⍬
  COVER_step ⍬
∇

∇ load_display_if_not_already_loaded
        :If 0=⎕NC '#.DISPLAY'
                'DISPLAY' #.⎕CY 'display'
        :EndIf
∇

∇ load_salt_scripts_into_current_namespace_if_configured
  :if 0≠⎕NC '#.UT.appdir'
          :if ⍬≢#.UT.appdir
                  ⎕SE.SALT.Load #.UT.appdir,'src/*.dyalog -target=#'
                  ⎕SE.SALT.Load #.UT.appdir,'test/*.dyalog -target=#'
          :endif
  :endif
∇

∇ Z ← FromSpace single_function_test_function TestName
        Z ← run_ut FromSpace TestName
∇

∇ Z ← FromSpace list_of_functions_test_function ListOfNames;t
  t←⎕TS
  Z ← run_ut ¨ { FromSpace ⍵ } ¨ ListOfNames
  t←⎕TS-t
  ('Test execution report') print_passed_crashed_failed Z t
∇

∇ Z ← FromSpace file_test_function FilePath;FileNS;Functions;TestFunctions;t
  FileNS ← ⎕SE.SALT.Load FilePath,' -target=#'
  Functions  ← ↓ FileNS.⎕NL 3
  TestFunctions ←  (is_test ¨ Functions) / Functions
  :if (0/⍬,⊂0/'') ≡ TestFunctions
          ⎕←'No test functions found'
          Z ← ⍬
  :else
          t ← ⎕TS
          Z ← run_ut ¨ { FileNS ⍵ } ¨ TestFunctions
          t ← ⎕TS-t
          (FilePath,' tests') print_passed_crashed_failed Z t
  :endif
∇

∇ Z ← FromSpace test_dir_function Test_files
  :if Test_files≡⍬/⍬,⊂''
          ⎕←'No test files found'
          Z←⍬
  :else
          Z←#.UT.run ¨ Test_files
  :endif
∇

∇ Z ← get_file_name Argument;separator
        separator ← ⌈ / ('/' = Argument) / ⍳ ⍴ Argument
        Z ← ¯7 ↓ separator ↓ Argument
∇

∇ generate_coverage_page Conf;ProfileData;CoverResults;HTML
        ProfileData ← ⎕PROFILE 'data'       
        ToCover ← retrieve_coverables ¨ (⊃'cover_target' in Conf)
        :if (⍴ToCover) ≡ (⍴⊂1)
                ToCover ← ⊃ ToCover
        :endif
        Representations ← get_representation ¨ ToCover
        CoverResults ← ProfileData∘generate_cover_result ¨ ↓ ToCover,[1.5]Representations
        HTML ← generate_html CoverResults
        Conf write_html_to_page HTML
        ⎕PROFILE 'clear'
∇

∇ Z ← retrieve_coverables Something;nc;functions
  nc ← ⎕NC Something
  :if nc = 3
          Z ← Something
  :elseif nc = 9
          functions ← strip ¨ ↓ ⍎ Something,'.⎕NL 3'
          Z ← { (Something,'.',⍵) } ¨ functions 
  :endif
∇

∇ Z ← strip input
  Z ← (input≠' ')/input
∇

∇ Z ← get_representation Function;nc;rep
  nc ← ⎕NC ⊂Function
  :if nc = 3.1
          rep ← ↓ ⎕CR Function
          rep[1] ← ⊂'∇',⊃rep[1]
          rep,← ⊂'∇'
          rep ← ↑ rep 
  :else
          rep ← ⎕CR Function
  :endif
  Z ← rep
∇

∇ Z ← ProfileData generate_cover_result (name representation);Indices;lines;functionlines;covered_lines
  Indices ← ({ name ≡ ⍵ } ¨ ProfileData[;1]) / ⍳ ⍴ ProfileData[;1]
  lines ← ProfileData[Indices;2]        
  nc ← ⎕NC ⊂name
  :if 3.1 = nc
          functionlines ← ¯2 + ⍴ ↓ representation
  :else
          functionlines ← ⊃ ⍴ ↓ representation
  :endif
  covered_lines ← (⍬∘≢ ¨ lines) / lines
  Z ← (nc lines functionlines covered_lines representation)
∇

∇ Z ← generate_html CoverResults;Covered;Total;Percentage;CoverageText;ColorizedCode;Timestamp;Page
        Covered ← ⊃⊃+/ { ⍴ 4 ⊃ ⍵ } ¨ CoverResults
        Total ← ⊃⊃+/ { 3⊃⍵ } ¨ CoverResults
        Percentage ← 100 × Covered ÷ Total
        CoverageText ← 'Coverage: ',Percentage,'% (',Covered,'/',Total,')'
        ColorizedCode ← ⊃ ,/ { colorize_code_by_coverage ⍵ } ¨ CoverResults
        Timestamp ← generate_timestamp_text
        Page ← ⍬
        Page ,← ⊂ ⍬,'<html>'
        Page ,← ⊂ ⍬,'<meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>'
        Page ,← ⊂ ⍬,CoverageText
        Page ,← ColorizedCode
        Page ,← Timestamp
        Page ,← ⊂ ⍬,'</html>'
        Z ← Page
∇

∇ Z ← colorize_code_by_coverage CoverResult;Color;red_font;green_font;black_font;end_of_line
        Color ← { '<font color=',⍵,'><pre>' } 
        red_font ← Color 'red'
        green_font ← Color 'green'
        black_font ← Color 'black'
        end_of_line ← '</pre></font>'

        :if 3.1=⊃CoverResult
                Colors ← (2  + 3⊃CoverResult) ⍴ ⊂ ⍬,red_font
                Colors[1] ← ⊂ black_font
                Colors[⍴Colors] ← ⊂ black_font
        :else
                Colors ← (3⊃CoverResult) ⍴ ⊂ ⍬,red_font
        :endif
        Colors[1+4⊃CoverResult] ← ⊂ ⍬,green_font

        Code ← ↓ 5⊃CoverResult
        Z ← Colors,[1.5]Code
        Z ← {⍺,(⎕UCS 13),⍵ }/ Z, (⍴ Code) ⍴ ⊂ ⍬,end_of_line
∇

∇ Z ← generate_timestamp_text;TS;YYMMDD;HHMMSS
        TS ← ⎕TS
        YYMMDD ← ⊃ { ⍺,'-',⍵} / 3 ↑ TS
        HHMMSS ← ⊃ { ⍺,':',⍵} / 3 ↑ 3 ↓ TS
        Z ← 'Page generated: ',YYMMDD,'|',HHMMSS
∇

∇ Conf write_html_to_page Page;tie;filename
        filename ← (⊃'cover_out' in Conf),(⊃'cover_file' in Conf)
        :Trap 22
                tie ← filename ⎕NTIE 0
                filename ⎕NERASE tie
                filename ⎕NCREATE tie
        :Else
                tie ← filename ⎕NCREATE 0
        :EndTrap
        Simple_array ← ⍕ ⊃ ,/ Page
        (⎕UCS 'UTF-8' ⎕UCS Simple_array) ⎕NAPPEND tie
∇

∇ Z ← is_function Argument
        Z ← '_TEST' ≡ ¯5 ↑ Argument
∇

∇ Z ← is_list_of_functions Argument
        Z ← 2 =≡ Argument
∇

∇ Z ← is_file Argument
        Z ← '.dyalog' ≡ ¯7 ↑ Argument
∇

∇ Z ← is_dir Argument
  :if 'Linux'≡⊃'.'⎕WG'APLVersion'
          Z ← 'yes' ≡ ⊃ ⎕CMD 'test -d ',Argument,' && echo yes || echo no'
  :else
          'gfa'⎕NA  'I kernel32|GetFileAttributes* <0t'
          attr←gfa⊂Argument
          Z←1=4⊃2 2 2 2 2 2 2 2⊤attr
  :endif
∇

∇ Z ← test_files_in_dir Argument 
  :if 'Linux'≡⊃'.'⎕WG'APLVersion'          
          Z ← ⎕SH 'find ',Argument,' -name \*_tests.dyalog'
  :else
          #.⎕CY 'files'
          Z ← Files.Dir Argument,'\*_tests.dyalog'
  :endif
∇

∇ Z ← run_ut ut_data;returned;crashed;pass;crash;fail;message
        (returned crashed time) ← execute_function ut_data
        (pass crash fail) ← determine_pass_crash_or_fail returned crashed
        message ← determine_message pass fail crashed (2⊃ut_data) returned time
        print_message_to_screen message
        Z ← (pass crash fail)
∇

∇ Z ← execute_function ut_data;function;t
        reset_UT_globals
        function ← (⍕(⊃ut_data[1])),'.',⊃ut_data[2]
        :Trap sac
                :if 3.2 ≡ ⎕NC ⊂function
                        t ← ⎕TS
                        Z ← (⍎ function,' ⍬') 0
                        t ← ⎕TS-t
                :else
                        t ← ⎕TS
                        Z ← (⍎ function)  0
                        t ← ⎕TS-t
                :endif
                
        :Else
                Z ← (↑ ⎕DM) 1
                :If exception ≢ ⍬
                        expect ← exception
                        Z[2] ← 0
                        t ← ⎕TS-t
                :EndIf
        :EndTrap
        Z,← ⊂t
∇

∇ reset_UT_globals
        expect ← ⍬
        exception ← ⍬
        nexpect ← ⍬  
∇

∇ Z ← is_test FunctionName;wsIndex
        wsIndex ← FunctionName ⍳ ' '
        FunctionName ← (wsIndex - 1) ↑ FunctionName
        Z ← '_TEST' ≡ ¯5 ↑ FunctionName
∇

∇ Heading print_passed_crashed_failed (ArrayRes time)
  ⎕ ← '-----------------------------------------'
  ⎕ ← Heading
  ⎕ ← '    ⍋  Passed: ',+/ { 1⊃⍵ } ¨ ArrayRes
  ⎕ ← '    ⍟ Crashed: ',+/ { 2⊃⍵ } ¨ ArrayRes
  ⎕ ← '    ⍒  Failed: ',+/ { 3⊃⍵ } ¨ ArrayRes
  ⎕ ← '    ○ Runtime: ',time[5],'m',time[6],'s',time[7],'ms'
∇

∇ Z ← determine_pass_crash_or_fail (returned crashed)
        :If 0 = crashed
                argument ← ⊃ (⍬∘≢ ¨ #.UT.expect #.UT.nexpect) / #.UT.expect #.UT.nexpect
                comparator ← (⍬∘≢ ¨ #.UT.expect #.UT.nexpect) / '≡' '≢'                 
                :if argument (⍎comparator) returned
                        Z ← 1 0 0
                :else
                        Z ← 0 0 1
                :endif
        :Else
                Z ← 0 1 0
        :EndIf
∇

∇ Z ← determine_message (pass fail crashed name returned time)
        :If crashed
                Z ← 'CRASHED: ' failure_message name returned
        :ElseIf pass
                Z ← 'Passed ',time[5],'m',time[6],'s',time[7],'ms'
        :Else
                Z ← 'FAILED: ' failure_message name returned
        :EndIf
∇

∇ print_message_to_screen message
        ⎕ ← message
∇

∇ Z ← term_to_text Term;Text;Rows
        Text ← #.DISPLAY Term
        Rows ← 1 ⊃ ⍴ Text
        Z ← (Rows 4 ⍴ ''),Text
∇

∇ Z ← Cause failure_message (name returned);hdr;exp;expterm;got;gotterm
        hdr ← Cause,name
        exp ← 'Expected'
        expterm ← term_to_text #.UT.expect
        got ← 'Got'
        gotterm ← term_to_text returned
        Z ← align_and_join_message_parts hdr exp expterm got gotterm
∇

∇ Z ← align_and_join_message_parts Parts;hdr;exp;expterm;got;gotterm;R1;C1;R2;C2;W
        (hdr exp expterm got gotterm) ← Parts
        (R1 C1) ← ⍴ expterm
        (R2 C2) ← ⍴ gotterm
        W ← ⊃ ⊃ ⌈ / C1 C2 (⍴ hdr) (⍴ exp) (⍴ got) 
        Z ← (W ↑ hdr),[0.5] (W ↑ exp)
        Z ← Z⍪(R1 W ↑ expterm)
        Z ← Z⍪(W ↑ got)
        Z ← Z⍪(R2 W ↑ gotterm)
∇

∇ Z ← confparam in config
  Z ← 1↓⊃({confparam≡⊃⍵} ¨ config)/config
∇

∇ Z ← config has confparam
  Z ← ∨/{confparam≡⊃⍵} ¨config
∇

:EndNameSpace