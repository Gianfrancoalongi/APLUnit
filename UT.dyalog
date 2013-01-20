
:NameSpace UT

expect ← ⍬
passed ← 0
failed ← 0

∇ run_tests Tests
        ⎕CS 1 ⊃ ⎕NSI
        #.UT.passed ← 0
        #.UT.failed ← 0
        #.UT.run ¨ Tests
        #.UT.print_result_of_array_test
∇

∇ print_result_of_array_test
        ⎕ ← 'Text execution report'
        ⎕ ← '    ⍋ Passed: ',#.UT.passed
        ⎕ ← '    ⍒ Failed: ',#.UT.failed
∇

∇ run Function;FunctionResult;Tmp
        Tmp ← 1 ⊃ ⎕RSI
        Tmp ← (⍕ ⎕THIS) ⎕NS ((⍕ Tmp),'.',Function)
        FunctionResult ← execute_function Function
        Function test_result_printed_to_screen FunctionResult  
        ⎕EX Function
∇

∇ Z ← execute_function Name
        Z ← ⍎ Name
∇

∇ Z ← Function test_result_printed_to_screen FunctionResult
        :If matches_expected FunctionResult
                ⎕ ← 'Passed'
                #.UT.passed ← #.UT.passed + 1
        :Else
                #.UT.failed ← #.UT.failed + 1
                Function display_expected_got FunctionResult
        :EndIf
∇

∇ Z ← matches_expected FunctionResult
        Z ← expect ≡ FunctionResult
∇

∇ Z ← term_to_text Term;Text;Rows
        Text ← #.DISPLAY Term
        Rows ← 1 ⊃ ⍴ Text
        Z ← (Rows 4 ⍴ ''),Text
∇

∇ Name display_expected_got Result
        ⎕ ← 'FAILED:',Name 
        ⎕ ← 'Expected'
        ⎕ ← term_to_text expect
        ⎕ ← 'Got'
        ⎕ ← term_to_text Result
∇

:EndNameSpace