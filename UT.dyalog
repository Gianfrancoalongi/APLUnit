
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

expect ← ⍬

∇ run_tests Tests;ArrayRes
        ⎕CS 1 ⊃ ⎕NSI
        ArrayRes ← #.UT.run ¨ Tests
        #.UT.print_result_of_array_test ArrayRes
∇

∇ print_result_of_array_test ArrayRes
        ⎕ ← '-----------------------------------------'
        ⎕ ← 'Text execution report'
        ⎕ ← '    ⍋  Passed: ',+/ { ⍵.Passed } ¨ ArrayRes
        ⎕ ← '    ⍟ Crashed: ',+/ { ⍵.Crashed } ¨ ArrayRes
        ⎕ ← '    ⍒  Failed: ',+/ { ⍵.Failed } ¨ ArrayRes
∇

∇ Z ← run Function;FunctionResult;Tmp;UTRes
        Tmp ← 1 ⊃ ⎕RSI
        Tmp ← (⍕ ⎕THIS) ⎕NS ((⍕ Tmp),'.',Function)
        UTRes ← execute_function Function
        determine_pass_fail UTRes
        determine_message UTRes
        print_message_to_screen UTRes
        ⎕EX Function
        Z ← UTRes
∇

∇ Z ← execute_function Name;UTRes
        UTRes ← ⎕NEW UTresult
        UTRes.Name ← Name
        :Trap 0
                UTRes.Returned ← ⍎ Name
        :Else
                UTRes.Crashed ← 1
        :EndTrap
        Z ← UTRes                
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

∇ Z ← crash_message UTRes
        expectedTerm ← term_to_text #.UT.expect
        resultTerm ← ↑ ⎕DM
        header ← 'CRASHED: ',UTRes.Name
        expected ← 'Expected'
        (R1 C1) ← ⍴ expectedTerm
        got ← 'Got'
        (R2 C2) ← ⍴ resultTerm
        W ← ⊃ ⊃ ⌈ / C1 C2 (⍴ header) (⍴ expected) (⍴ got) 
        Z ← (W ↑ header),[0.5] (W ↑ expected)
        Z ← Z⍪(R2 W ↑ expectedTerm)
        Z ← Z⍪(W ↑ got)
        Z ← Z⍪(R1 W ↑ resultTerm)
∇

∇ Z ← failure_message UTRes;expectedTerm;resultTerm;header;expected;got;W;R1;C1;R2;C2
        expectedTerm ← term_to_text #.UT.expect
        resultTerm ← term_to_text UTRes.Returned
        header ← 'FAILED: ',UTRes.Name
        expected ← 'Expected'
        (R1 C1) ← ⍴ expectedTerm
        got ← 'Got'
        (R2 C2) ← ⍴ resultTerm
        W ← ⊃ ⊃ ⌈ / C1 C2 (⍴ header) (⍴ expected) (⍴ got) 
        Z ← (W ↑ header),[0.5] (W ↑ expected)
        Z ← Z⍪(R2 W ↑ expectedTerm)
        Z ← Z⍪(W ↑ got)
        Z ← Z⍪(R1 W ↑ resultTerm)
∇

:EndNameSpace