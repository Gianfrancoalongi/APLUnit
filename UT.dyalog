:NameSpace UT

    sac ← 0
    expect ← ⍬
    exception ← ⍬
    nexpect ← ⍬

    ∇ {Z}←{Conf}run Argument;from_space;tests;results;t_s;t_e
     
      load_display_if_not_already_loaded
     
      load_salt_scripts_into_current_namespace_if_configured
     
      from_space←1⊃⎕RSI
     
      tests←from_space determine_list_of_tests Argument
      :If 0=≢tests
          ⎕←'No tests to run'
          Z←⍬
      :Else
          t_s←⎕TS
          results←execute_all tests
          t_e←⎕TS-t_s
          Argument display_execution_report results t_e
          Z←results
      :EndIf
    ∇

    ∇ load_display_if_not_already_loaded
      :If 0=⎕NC'#.DISPLAY'
          'DISPLAY'#.⎕CY'display'
      :EndIf
    ∇

    ∇ load_salt_scripts_into_current_namespace_if_configured
      :If 0≠⎕NC'#.UT.appdir'
          :If ⍬≢#.UT.appdir
              ⎕SE.SALT.Load #.UT.appdir,'src/*.dyalog -target=#'
              ⎕SE.SALT.Load #.UT.appdir,'test/*.dyalog -target=#'
          :EndIf
      :EndIf
    ∇

    ∇ Z←FromSpace determine_list_of_tests Argument;test_files;test_functions
      :If is_function Argument
          Z←⊂,(FromSpace Argument)
     
      :ElseIf is_list_of_functions Argument
          Z←{FromSpace ⍵}¨Argument
     
      :ElseIf is_file Argument
          Z←FromSpace file_test_functions Argument
     
      :ElseIf is_dir Argument
          test_files←test_files_in_dir Argument
          :If 0=≢test_files
              Z←⍬
          :Else
              test_functions←FromSpace∘determine_list_of_tests¨test_files
              Z←⊃,/test_functions
          :EndIf
      :EndIf
    ∇

    ∇ Z←execute_all tests
      Z←run_ut¨tests
    ∇

    ∇ Argument display_execution_report test_result;rh
      rh←determine_report_heading Argument
      rh print_passed_crashed_failed test_result
    ∇
    
    ∇ Z←determine_report_heading Argument;heading
      heading←'Test execution report'
      :If is_function Argument
          Z←heading
      :ElseIf is_list_of_functions Argument
          Z←heading,' for ',(⍕⍴Argument),' tests'
      :ElseIf is_file Argument
          Z←heading,' for ',Argument
      :ElseIf is_dir Argument
          Z←heading,' for ',Argument
      :EndIf
    ∇

    ∇ Z←FromSpace file_test_functions FilePath;FileNS;Functions;TestFunctions;t
      FileNS←⎕SE.SALT.Load FilePath,' -target=#'
      Functions←↓FileNS.⎕NL 3
      TestFunctions←(is_test¨Functions)/Functions
      :If (0/⍬,⊂0/'')≡TestFunctions
          Z←⍬
      :Else
          Z←{FileNS ⍵}¨TestFunctions
      :EndIf
    ∇

    ∇ Z←get_file_name Argument;separator
      separator←⌈/(Argument∊'/\')/⍳⍴Argument
      Z←¯7↓separator↓Argument
    ∇

    ∇ Z←is_function Argument
      Z←'_TEST'≡¯5↑Argument
    ∇

    ∇ Z←is_list_of_functions Argument
      Z←2=≡Argument
    ∇

    ∇ Z←is_file Argument
      Z←'.dyalog'≡¯7↑Argument
    ∇

    ∇ Z←is_dir Argument;attr
      :If 'Linux'≡5↑⊃'.'⎕WG'APLVersion'
          Z←'yes'≡⊃⎕CMD'test -d ',Argument,' && echo yes || echo no'
      :Else
          'gfa'⎕NA'I kernel32|GetFileAttributes* <0t'
          :If Z←¯1≠attr←gfa⊂Argument ⍝ If file exists
              Z←⊃2 16⊤attr           ⍝ Return bit 4
          :EndIf
      :EndIf
    ∇

    ∇ Z←test_files_in_dir Argument
      :If 'Linux'≡5↑⊃'.'⎕WG'APLVersion'
          Z←⎕SH'find ',Argument,' -name \*_tests.dyalog'
      :Else
          #.⎕CY'files'
          Z←#.Files.Dir Argument,'\*_tests.dyalog'
          Z←(Argument,'\')∘,¨Z
      :EndIf
    ∇

    ∇ Z←run_ut ut_data;returned;crashed;pass;crash;fail
      (returned crashed time)←execute_function ut_data
      (pass crash fail)←determine_pass_crash_or_fail returned crashed
      ⎕←determine_message pass fail crashed(2⊃ut_data)returned time
      Z←(pass crash fail)
    ∇

    ∇ Z←execute_function ut_data;function;t
      reset_UT_globals
      function←(⍕(⊃ut_data[1])),'.',⊃ut_data[2]
      :Trap sac
          :If 3.2≡⎕NC⊂function
              t←⎕TS
              Z←(⍎function,' ⍬')0
              t←⎕TS-t
          :Else
              t←⎕TS
              Z←(⍎function)0
              t←⎕TS-t
          :EndIf
     
      :Else
          Z←(↑⎕DM)1
          :If exception≢⍬
              expect←exception
              Z[2]←0
              t←⎕TS-t
          :EndIf
      :EndTrap
      Z,←⊂t
    ∇

    ∇ reset_UT_globals
      expect←⍬
      exception←⍬
      nexpect←⍬
    ∇

    ∇ Z←is_test FunctionName;wsIndex
      wsIndex←FunctionName⍳' '
      FunctionName←(wsIndex-1)↑FunctionName
      Z←'_TEST'≡¯5↑FunctionName
    ∇

    ∇ Heading print_passed_crashed_failed(ArrayRes time)
      ⎕←'-----------------------------------------'
      ⎕←Heading
      ⎕←'    ⍋  Passed: ',+/{1⊃⍵}¨ArrayRes
      ⎕←'    ⍟ Crashed: ',+/{2⊃⍵}¨ArrayRes
      ⎕←'    ⍒  Failed: ',+/{3⊃⍵}¨ArrayRes
      ⎕←'    ○ Runtime: ',time[5],'m',time[6],'s',time[7],'ms'
    ∇

    ∇ Z←determine_pass_crash_or_fail(returned crashed)
      :If 0=crashed
          argument←⊃(⍬∘≢¨#.UT.expect #.UT.nexpect)/#.UT.expect #.UT.nexpect
          comparator←(⍬∘≢¨#.UT.expect #.UT.nexpect)/'≡' '≢'
          :If argument(⍎comparator)returned
              Z←1 0 0
          :Else
              Z←0 0 1
          :EndIf
      :Else
          Z←0 1 0
      :EndIf
    ∇

    ∇ Z←determine_message(pass fail crashed name returned time)
      :If crashed
          Z←'CRASHED: 'failure_message name returned
      :ElseIf pass
          Z←'Passed ',time[5],'m',time[6],'s',time[7],'ms'
      :Else
          Z←'FAILED: 'failure_message name returned
      :EndIf
    ∇

    ∇ Z←term_to_text Term;Text;Rows
      Text←#.DISPLAY Term
      Rows←1⊃⍴Text
      Z←(Rows 4⍴''),Text
    ∇

    ∇ Z←Cause failure_message(name returned);hdr;exp;expterm;got;gotterm
      hdr←Cause,name
      exp←'Expected'
      expterm←term_to_text #.UT.expect
      got←'Got'
      gotterm←term_to_text returned
      Z←align_and_join_message_parts hdr exp expterm got gotterm
    ∇

    ∇ Z←align_and_join_message_parts Parts;hdr;exp;expterm;got;gotterm;R1;C1;R2;C2;W
      (hdr exp expterm got gotterm)←Parts
      (R1 C1)←⍴expterm
      (R2 C2)←⍴gotterm
      W←⊃⊃⌈/C1 C2(⍴hdr)(⍴exp)(⍴got)
      Z←(W↑hdr),[0.5](W↑exp)
      Z←Z⍪(R1 W↑expterm)
      Z←Z⍪(W↑got)
      Z←Z⍪(R2 W↑gotterm)
    ∇

:EndNameSpace