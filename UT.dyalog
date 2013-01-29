
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

expect ← ⍬
exception ← ⍬

∇ run Argument;testobject;UTObjs;ArrayRes;FromSpace;LoadedNameSpace;FunctionsFromNameSpace;TestFunctions

        :If is_function Argument
                testobject ← ⎕NEW UTobj (1 ⊃ ⎕RSI)
                testobject.FunctionName ← Argument
                run_ut_obj testobject        

        :ElseIf is_list_of_functions Argument
                FromSpace ← (1 ⊃ ⎕RSI) 
                UTobjs ← { ⎕NEW UTobj FromSpace } ¨ Argument
                { UTobjs[⍵].FunctionName ← ⊃ Argument[⍵] } ¨ ⍳ ⍴ Argument
                ArrayRes ← run_ut_obj ¨ UTobjs
                print_result_of_array_test ArrayRes

        :ElseIf is_file Argument
                LoadedNameSpace ← ⎕SE.SALT.Load Argument
                FunctionsFromNameSpace  ← ↓ LoadedNameSpace.⎕NL 3
                TestFunctions ←  (is_test ¨ FunctionsFromNameSpace) / FunctionsFromNameSpace
                UTobjs ← { ⎕NEW UTobj LoadedNameSpace } ¨ TestFunctions
                { UTobjs[⍵].FunctionName ← ⊃ TestFunctions[⍵] } ¨ ⍳ ⍴ TestFunctions
                ArrayRes ← run_ut_obj ¨ UTobjs
                Argument print_result_of_file_test ArrayRes
                ⎕EX (⍕ LoadedNameSpace)
                
        :EndIf
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
                :If exception ≢ ⍬
                        expect ← exception
                        UTRes.Returned ← 1 ⊃ ⎕DM
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
        ⎕ ← '-----------------------------------------'
        ⎕ ← FilePath,' tests'
        print_passed_crashed_failed ArrayRes
∇

∇ print_result_of_array_test ArrayRes
        ⎕ ← '-----------------------------------------'
        ⎕ ← 'Text execution report'
        print_passed_crashed_failed ArrayRes
 ∇

∇ print_passed_crashed_failed ArrayRes
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
                UTRes.Text ← crash_message UTRes
        :ElseIf UTRes.Passed
                UTRes.Text ← 'Passed'
        :Else
                UTRes.Text ← failure_message UTRes
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

∇ Z ← crash_message UTRes;hdr;exp;expterm;got;gotterm
        hdr ← 'CRASHED: ',UTRes.Name
        exp ← 'Expected'
        expterm ← term_to_text #.UT.expect
        got ← 'Got'
        gotterm ← ↑ ⎕DM
        Z ← align_and_join_message_parts hdr exp expterm got gotterm
∇

∇ Z ← failure_message UTRes;hdr;exp;expterm;got;gotterm
        hdr ← 'FAILED: ',UTRes.Name
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