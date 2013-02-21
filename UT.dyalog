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

∇ {CoverConf} run Argument;PRE_test;POST_test;TEST_step;COVER_step_function;COVER_step;FromSpace

        FromSpace ← 1 ⊃ ⎕RSI

        PRE_test ← {}
        POST_test ← {}
        COVER_step ← {} 
        :If 0 ≠ ⎕NC 'CoverConf'
                PRE_test ← { ⎕PROFILE 'start' }
                POST_test ← { ⎕PROFILE 'stop' }
        :EndIf

        :If is_function Argument                
                TEST_step ← single_function_test_function
                COVER_step_function ← single_function_cover

        :ElseIf is_list_of_functions Argument                
                TEST_step ← list_of_functions_test_function
                COVER_step_function ← list_of_functions_cover

        :ElseIf is_file Argument
                TEST_step ← file_test_function
                COVER_step_function ← file_cover
        :EndIf

        :If 0 ≠ ⎕NC 'CoverConf'
                COVER_step ← { CoverConf COVER_step_function Argument }
        :EndIf                

        PRE_test ⍬
        FromSpace TEST_step Argument
        POST_test ⍬
        COVER_step ⍬
∇

∇ FromSpace single_function_test_function TestName;testobject
        testobject ← ⎕NEW UTobj FromSpace
        testobject.FunctionName ← TestName
        run_ut_obj testobject
∇

∇ FromSpace list_of_functions_test_function ListOfNames;UTobjs
        UTobjs ← { ⎕NEW UTobj FromSpace } ¨ ListOfNames
        { UTobjs[⍵].FunctionName ← ⊃ ListOfNames[⍵] } ¨ ⍳ ⍴ ListOfNames
        ('Text execution report') print_passed_crashed_failed run_ut_obj ¨ UTobjs
∇

∇ FromSpace file_test_function FilePath;FileNS;Functions;TestFunctions;UTobjs
        FileNS ← ⎕SE.SALT.Load FilePath
        Functions  ← ↓ FileNS.⎕NL 3
        TestFunctions ←  (is_test ¨ Functions) / Functions
        UTobjs ← { ⎕NEW UTobj FileNS } ¨ TestFunctions
        { UTobjs[⍵].FunctionName ← ⊃ TestFunctions[⍵] } ¨ ⍳ ⍴ TestFunctions
        (FilePath,' tests') print_passed_crashed_failed run_ut_obj ¨ UTobjs
        ⎕EX (⍕ FileNS)
∇

∇ CoverConf single_function_cover TestName
        CoverConf.Page_name ← TestName,'_coverage.html'
        generate_coverage_page CoverConf
∇

∇ CoverConf list_of_functions_cover Args
        CoverConf.Page_name ← 'list_coverage.html'
        generate_coverage_page CoverConf
∇

∇ CoverConf file_cover FilePath
        CoverConf.Page_name ← (get_file_name FilePath),'_coverage.html'
        generate_coverage_page CoverConf
∇

∇ generate_coverage_page CoverConf;ProfileData;CoverResults;HTML
        ProfileData ← ⎕PROFILE 'data'
        CoverResults ← { ProfileData generate_cover_result ⍵ (⎕CR ⍵) } ¨ CoverConf.Cover
        HTML ← generate_html CoverResults
        CoverConf write_html_to_page HTML
        ⎕PROFILE 'clear'
∇

∇ Z ← get_file_name Argument;separator
        separator ← ⌈ / ('/' = Argument) / ⍳ ⍴ Argument
        Z ← ¯7 ↓ separator ↓ Argument
∇

∇ Z ← ProfileData generate_cover_result Args;FunctionName;FunctionVR;Indices;Line;Res
        (FunctionName Representation) ← Args
        Indices ← (FunctionName∘≡¨ ProfileData[;1]) / ⍳ ⍴ ProfileData[;1]
        Lines ← ProfileData[Indices;2]
        Res ← ⎕NEW CoverResult
        Res.CoveredLines ← (⍬∘≢ ¨ Lines) / Lines
        Res.FunctionLines ← ¯1 + ⍴ ↓ Representation
        Res.Representation ← Representation
        Z ← Res
∇

∇ Z ← generate_html CoverResults;TotalCov;Covered;Total;Percentage;CoverageText;ColorizedCode;Timestamp;Page
        TotalCov ← ⎕NEW CoverResult
        Covered ← ⊃⊃+/ { ⍴ ⍵.CoveredLines } ¨ CoverResults
        Total ← ⊃⊃+/ { ⍵.FunctionLines } ¨ CoverResults
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

        Code ← ↓ CoverResult.Representation
        Code[1] ← ⊂'∇',⊃Code[1]
        Code ,← ⊂'∇'

        Colors ← (2 + CoverResult.FunctionLines) ⍴ ⊂ ⍬,red_font

        Colors[1] ← ⊂ black_font
        Colors[⍴Colors] ← ⊂ black_font

        Colors[ 1 + CoverResult.CoveredLines ] ← ⊂ ⍬,green_font

        Z ← Colors,[1.5]Code
        Z ← {⍺,(⎕UCS 13),⍵ }/ Z, (⍴ Code) ⍴ ⊂ ⍬,end_of_line
∇

∇ Z ← generate_timestamp_text;TS;YYMMDD;HHMMSS
        TS ← ⎕TS
        YYMMDD ← ⊃ { ⍺,'-',⍵} / 3 ↑ TS
        HHMMSS ← ⊃ { ⍺,':',⍵} / 3 ↑ 3 ↓ TS
        Z ← 'Page generated: ',YYMMDD,'|',HHMMSS
∇

∇ CoverConf write_html_to_page Page;tie;filename
        filename ← CoverConf.Pages,CoverConf.Page_name
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

∇ Z ← run_ut_obj testobject;UTRes
        UTRes ← execute_function testobject
        determine_pass_or_fail UTRes
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

∇ Heading print_passed_crashed_failed ArrayRes
        ⎕ ← '-----------------------------------------'
        ⎕ ← Heading
        ⎕ ← '    ⍋  Passed: ',+/ { ⍵.Passed } ¨ ArrayRes
        ⎕ ← '    ⍟ Crashed: ',+/ { ⍵.Crashed } ¨ ArrayRes
        ⎕ ← '    ⍒  Failed: ',+/ { ⍵.Failed } ¨ ArrayRes
∇

∇ determine_pass_or_fail UTRes
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