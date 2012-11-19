:NameSpace UT

EN ← ⍬
DM ← ⍬

∇ Z ← LHS eq RHS
        Z ← 1
        :If LHS ≢ RHS
                Z ← LHS RHS
        :EndIf
∇

∇ Z ← run Function;Res;Tmp        
        Tmp ← 1 ⊃ ⎕RSI
        Tmp ← (⍕ ⎕THIS) ⎕NS ((⍕ Tmp),'.',Function)
        :Trap 0
                Res ← execute_function Function
                Z ← Res
                :If 1 = ⍴⍴ Res
                        Function display_expected_got Res
                        Z ← 0
                :EndIf
        :Else
                :If EN ≢ ⍬
                        Z ← 1
                        :If EN ≢ ⎕EN                                
                                Z ← 0                        
                        :EndIf
                        EN ← ⍬
                        DM ← ⍬
                :Else
                        display_exception Function
                        Z ← ⎕EN
                :EndIf
        :EndTrap
        ⎕EX Function
∇

∇ Z ← execute_function Name;R;C
        (R C) ← ⍴ ⎕CR Name
        :If R > 1 
                Z ← ⍎ Name
        :Else
                Z ← ⍎ Name,' ⍬'
        :EndIf
∇

∇ Name display_expected_got Res
        ⎕ ← 'FAILED:',function_header Name 
        ⎕ ← 'Expected'
        ⎕ ← show_term ⊃Res[1]
        ⎕ ← 'Got'
        ⎕ ← show_term ⊃Res[2]
∇

∇ display_exception Name
        ⎕ ← 'EXCEPTION:',function_header Name 
        ⎕ ← ' LC:',⎕LC
        ⎕ ← ' EN:',⎕EN
        ⎕ ← ↑⎕DM
∇


∇ Z ← function_header Name;Matrix;R;C
        Matrix ← ⎕CR Name
        (R C) ← ⍴ Matrix
        :If R > 1
                Z ← ,Matrix[1;],' ... ',Matrix[R;]
        :Else
                Z ← ,Matrix
        :EndIf
∇

∇ Z ← show_term Term;Tmp
        :If 0=≡Term
                Z ← ' ',⍕Term
        :Else
                Tmp ← #.DISPLAY Term                
                Z ← ((⍴Tmp)[1] ⍴ ' '),Tmp
        :EndIf
∇

∇ Z ← run_file Path;TmpSpace;Fns;Res;Passed;Failed;Exception
        'TmpSpace' ⎕NS ''
        'TmpSpace' ⎕NS '#.DISPLAY' 
        {'TmpSpace'  ⎕NS ⍵ } ¨ ↓ #.UT.⎕NL 3
        ⎕CS 'TmpSpace'
        ⎕SE.SALT.Load Path
        ⎕CS get_namespace
        { (⍕ ⎕THIS) ⎕NS '#.UT.',⍵ } ¨ ↓ #.UT.⎕NL 3
        Fns ← ↓ ⎕THIS.⎕NL 3
        Fns ← ( is_test ¨ Fns) / Fns
        Res ← run ¨ Fns
        (Passed Exception Failed) ← (⊃+/1=Res) (⊃+/0≠Res∧1≠Res) (⊃+/0=Res) 
        print_file_result Passed Exception Failed
        ⎕CS ##
        ⎕CS ##
        ⎕EX 'TmpSpace'
        Z ← Passed Exception Failed
∇

∇ Z ← get_namespace
        Z ← ⊃ ↓ ⎕NL 9
∇

∇ Z ← is_test FunctionName;Index;Tmp
        Index ← FunctionName ⍳ ' '
        Tmp ← FunctionName
        :If Index ≤ ⍴ FunctionName
                Tmp ← FunctionName[⍳(¯1 + Index)]
        :EndIf
        Z ← '_TEST' ≡ ¯5 ↑ Tmp
∇

∇ print_file_result (Passed Exception Failed)
        ⎕ ← ''
        ⎕ ← Path 'unit tests'
        ⎕ ← '⍋ ',(⍕ Passed),' PASSED'
        ⎕ ← '⋄ ',(⍕ Exception),' EXCEPTION'
        ⎕ ← '⍒ ',(⍕ Failed),' FAILED'
∇

:EndNameSpace