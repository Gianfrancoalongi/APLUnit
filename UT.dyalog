
:NameSpace UT


:Class UTresult
        :Field Public Crashed
        :Field Public Passed
        :Field Public Failed
        :Field Public Text
        :Field Public Returned
        :Field Public Name

        ∇ UTresult
        :Access Public
        :Implements Constructor
        Crashed ← 0
        Passed ← 0
        Failed ← 0
        Returned ← ⍬
        Text ← ''
        Name ← ''
        ∇
:EndClass 

:Class UTobj
        :Field Public NameSpace
        :Field Public FunctionName
        
        ∇ testobj namespace
        :Access Public
        :Implements Constructor
        NameSpace ← namespace
        FunctionName ← ⍬
        ∇
:EndClass

:Class UTcover
        :Field Public Page_name
        :Field Public Pages
        :Field Public Cover
        
        ∇ coverobj
        :Access Public
        :Implements Constructor
        Pages ← ⍬
        Cover ← ⍬
        ∇
        
:EndClass

:Class CoverResult
        :Field Public CoveredLines
        :Field Public FunctionLines
        :Field Public Representation
        ∇ coverresult
        :Access Public
        :Implements Constructor
        CoveredLines ← ⍬
        FunctionLines ← ⍬
        Representation ← ⍬
        ∇
:EndClass

expect ← ⍬
exception ← ⍬

∇ {CoverConf} run Argument;PRE_test;POST_test;testobject;UTObjs;FromSpace;Functions;TestFunctions;FileNS

        FromSpace ← 1 ⊃ ⎕RSI
        :If 0 ≠ ⎕NC 'CoverConf'
                PRE_test ← { ⎕PROFILE 'start' }
                POST_test ← { ⎕PROFILE 'stop' }
        :Else
                PRE_test ← { }
                POST_test ← { }
        :EndIf


        :If is_function Argument

                PRE_test ⍬
              
                testobject ← ⎕NEW UTobj FromSpace
                testobject.FunctionName ← Argument
                run_ut_obj testobject        

                POST_test ⍬

                :If 0 ≠ ⎕NC 'CoverConf'
                        CoverConf.Page_name ← Argument,'_coverage.html'
                        CoverConf coverage_page_generation FromSpace
                :EndIf


        :ElseIf is_list_of_functions Argument
                
                PRE_test ⍬

                UTobjs ← { ⎕NEW UTobj FromSpace } ¨ Argument
                { UTobjs[⍵].FunctionName ← ⊃ Argument[⍵] } ¨ ⍳ ⍴ Argument
                print_result_of_array_test run_ut_obj ¨ UTobjs
                
                POST_test ⍬

                :If 0≠ ⎕NC 'CoverConf'
                        CoverConf.Page_name ← 'list_coverage.html'
                        CoverConf coverage_page_generation FromSpace
                :EndIf

        :ElseIf is_file Argument

                PRE_test ⍬

                FileNS ← ⎕SE.SALT.Load Argument
                Functions  ← ↓ FileNS.⎕NL 3
                TestFunctions ←  (is_test ¨ Functions) / Functions
                UTobjs ← { ⎕NEW UTobj FileNS } ¨ TestFunctions
                { UTobjs[⍵].FunctionName ← ⊃ TestFunctions[⍵] } ¨ ⍳ ⍴ TestFunctions
                Argument print_result_of_file_test run_ut_obj ¨ UTobjs
                ⎕EX (⍕ FileNS)

                POST_test ⍬

                :If 0≠ ⎕NC 'CoverConf'
                        CoverConf.Page_name ← (get_file_name Argument),'_coverage.html'
                        CoverConf coverage_page_generation FromSpace
                :EndIf

        :EndIf
∇

∇ CoverConf coverage_page_generation FromSpace;ProfileData;CheckForCoverage;CoverResults
        ProfileData ← ⎕PROFILE 'data'
        CheckForCoverage ← { (⍕ FromSpace),'.',⍵ } ¨ CoverConf.Cover                        
        CoverResults ← { ProfileData calc_cover ⍵ (⎕CR ⍵) } ¨ CheckForCoverage
        CoverConf write_cover_page generate_cover_page CoverResults
        ⎕PROFILE 'clear'
∇

∇ Z ← get_file_name Argument;separator
        separator ← ⌈ / ('/' = Argument) / ⍳ ⍴ Argument
        Z ← ¯7 ↓ separator ↓ Argument
∇

∇ Z ← ProfileData calc_cover Args;FunctionName;FunctionVR;Indices;Line;Res
        (FunctionName Representation) ← Args
        Indices ← (FunctionName∘≡¨ ProfileData[;1]) / ⍳ ⍴ ProfileData[;1]
        Lines ← ProfileData[Indices;2]
        Res ← ⎕NEW CoverResult
        Res.CoveredLines ← (⍬∘≢ ¨ Lines) / Lines
        Res.FunctionLines ← ¯1 + ⍴ ↓ Representation
        Res.Representation ← Representation
        Z ← Res
∇

∇ Z ← generate_cover_page CoverResults;TotalCov;Covered;Total;Percentage;CoverageText;ColorizedCode;Page
        TotalCov ← ⎕NEW CoverResult
        Covered ← ⊃⊃+/ { ⍴ ⍵.CoveredLines } ¨ CoverResults
        Total ← ⊃⊃+/ { ⍵.FunctionLines } ¨ CoverResults
        Percentage ← 100 × Covered ÷ Total
        CoverageText ← 'Coverage: ',Percentage,'% (',Covered,'/',Total,')'
        ColorizedCode ← ⊃ ,/ { colorize_code_by_coverage ⍵ } ¨ CoverResults
        Page ← ⍬
        Page ,← ⊂ ⍬,'<html>'
        Page ,← ⊂ ⍬,'<meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>'
        Page ,← ⊂ ⍬,CoverageText
        Page ,← ColorizedCode
        Page ,← ⊂ ⍬,'</html>'
        Z ← ↑ Page
∇

∇ Z ← colorize_code_by_coverage CoverResult;Color;red_font;green_font;black_font;end_of_line
        Color ← { '<font color=',⍵,'><pre>' } 
        red_font ← Color 'red'
        green_font ← Color 'green'
        black_font ← Color 'black'
        end_of_line ← '</pre></font>'

        Code ← ↓ CoverResult.Representation
        Code[1] ← ⊂'∇',⊃Code[1]
        Code ,← ⊂'∇'

        Colors ← (2 + CoverResult.FunctionLines) ⍴ ⊂ ⍬,red_font

        Colors[1] ← ⊂ black_font
        Colors[⍴Colors] ← ⊂ black_font

        Colors[ 1 + CoverResult.CoveredLines ] ← ⊂ ⍬,green_font

        Z ← Colors,[1.5]Code
        Z ← ,/ Z, (⍴ Code) ⍴ ⊂ ⍬,end_of_line
∇

∇ CoverConf write_cover_page Page;tie
        tie ← (CoverConf.Pages,CoverConf.Page_name) ⎕NCREATE 0
        Simple_array ← ⍕ ⊃ ,/ ↓ Page
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

∇ Z ← run_ut_obj testobject;UTRes
        UTRes ← execute_function testobject
        determine_pass_fail UTRes
        determine_message UTRes
        print_message_to_screen UTRes
        Z ← UTRes
∇

∇ Z ← execute_function testobject;UTRes
        UTRes ← ⎕NEW UTresult
        UTRes.Name ← testobject.FunctionName  
        reset_UT_globals
        :Trap 0
                UTRes.Returned ← ⍎ (⍕testobject.NameSpace),'.',testobject.FunctionName
        :Else
                UTRes.Returned ← 1 ⊃ ⎕DM
                :If exception ≢ ⍬
                        expect ← exception
                :Else
                        UTRes.Crashed ← 1
                :EndIf
        :EndTrap        
        Z ← UTRes                
∇

∇ reset_UT_globals
        expect ← ⍬
        exception ← ⍬
∇

∇ Z ← is_test FunctionName;wsIndex
        wsIndex ← FunctionName ⍳ ' '
        FunctionName ← (wsIndex - 1) ↑ FunctionName
        Z ← '_TEST' ≡ ¯5 ↑ FunctionName
∇

∇ run_test_objects TestObjects;ArrayRes
        ArrayRes ← run_ut_obj ¨ TestObjects
        print_result_of_array_test ArrayRes
∇

∇ FilePath print_result_of_file_test ArrayRes
        (FilePath,' tests') print_passed_crashed_failed ArrayRes
∇

∇ print_result_of_array_test ArrayRes
        ('Text execution report') print_passed_crashed_failed ArrayRes
 ∇

∇ Heading print_passed_crashed_failed ArrayRes
        ⎕ ← '-----------------------------------------'
        ⎕ ← Heading
        ⎕ ← '    ⍋  Passed: ',+/ { ⍵.Passed } ¨ ArrayRes
        ⎕ ← '    ⍟ Crashed: ',+/ { ⍵.Crashed } ¨ ArrayRes
        ⎕ ← '    ⍒  Failed: ',+/ { ⍵.Failed } ¨ ArrayRes
∇

∇ determine_pass_fail UTRes
        :If 0 = UTRes.Crashed                                 
                :If matches_expected UTRes
                        UTRes.Passed ← 1
                :Else
                        UTRes.Failed ← 1
                :EndIf
        :EndIf
∇

∇ determine_message UTRes
        :If UTRes.Crashed
                UTRes.Text ← 'CRASHED: ' failure_message UTRes
        :ElseIf UTRes.Passed
                UTRes.Text ← 'Passed'
        :Else
                UTRes.Text ← 'FAILED: ' failure_message UTRes
        :EndIf
∇

∇ print_message_to_screen UTRes
        ⎕ ← UTRes.Text
∇

∇ Z ← matches_expected UTRes
        Z ← expect ≡ UTRes.Returned
∇

∇ Z ← term_to_text Term;Text;Rows
        Text ← #.DISPLAY Term
        Rows ← 1 ⊃ ⍴ Text
        Z ← (Rows 4 ⍴ ''),Text
∇

∇ Z ← Cause failure_message UTRes;hdr;exp;expterm;got;gotterm
        hdr ← Cause,UTRes.Name
        exp ← 'Expected'
        expterm ← term_to_text #.UT.expect
        got ← 'Got'
        gotterm ← term_to_text UTRes.Returned
        Z ← align_and_join_message_parts hdr exp expterm got gotterm
∇

∇ Z ← align_and_join_message_parts Parts;hdr;exp;expterm;got;gotterm;R1;C1;R2;C2;W
        (hdr exp expterm got gotterm) ← Parts
        (R1 C1) ← ⍴ expterm
        (R2 C2) ← ⍴ gotterm
        W ← ⊃ ⊃ ⌈ / C1 C2 (⍴ hdr) (⍴ exp) (⍴ got) 
        Z ← (W ↑ hdr),[0.5] (W ↑ exp)
        Z ← Z⍪(R2 W ↑ expterm)
        Z ← Z⍪(W ↑ got)
        Z ← Z⍪(R1 W ↑ gotterm)
∇

:EndNameSpace