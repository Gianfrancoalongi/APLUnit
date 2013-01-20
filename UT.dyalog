
:NameSpace UT

expect ← ⍬

∇ Z ← run Function;FunctionResult;Tmp
        Tmp ← 1 ⊃ ⎕RSI
        Tmp ← (⍕ ⎕THIS) ⎕NS ((⍕ Tmp),'.',Function)
        FunctionResult ← execute_function Function
        Function test_result_printed_to_screen FunctionResult  
        ⎕EX Function
∇

∇ Z ← execute_function Name
        Z ← ⍎ Name
∇

∇ Function test_result_printed_to_screen FunctionResult
        :If matches_expected FunctionResult
                ⎕ ← 'Passed'        
        :Else
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