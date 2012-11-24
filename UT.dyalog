:NameSpace UT

EN ← ⍬

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
                :If #.UT.EN ≢ ⍬                        
                        Function display_expected_got #.UT.EN ⍬
                        Z ← 0
                        #.UT.EN ← ⍬
                :Else
                        Z ← Res
                        :If 1 = ⍴⍴ Res
                                Function display_expected_got Res
                                Z ← 0
                        :EndIf
                :EndIf
        :Else
                :If #.UT.EN ≢ ⍬
                        Z ← 1
                        :If #.UT.EN ≢ ⎕EN                                
                                Function display_expected_got #.UT.EN ⎕EN
                                Z ← 0                        
                        :EndIf
                        #.UT.EN ← ⍬
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
        {'TmpSpace'  ⎕NS ⍵ } ¨ ↓ #.UT.⎕NL 2
        ⎕CS 'TmpSpace'
        ⎕SE.SALT.Load Path
        ⎕CS get_namespace
        { (⍕ ⎕THIS) ⎕NS '#.UT.',⍵ } ¨ ↓ #.UT.⎕NL 3
        { (⍕ ⎕THIS) ⎕NS '#.UT.',⍵ } ¨ ↓ #.UT.⎕NL 2
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

∇ Z ← run_group Group;Res
        ⎕CS 1 ⊃ ⎕RSI
        Res ← #.UT.run ¨ (⍎ Group)
        ⎕CS #.UT
        Res ← (⊃+/1=Res) (⊃+/0≠Res∧1≠Res) (⊃+/0=Res) 
        Group print_group_result Res
        Z ← Res
∇

∇ Z ← Group run_group_file Path;Res
        'TmpSpace' ⎕NS ''
        ⎕CS 'TmpSpace'
        ⎕SE.SALT.Load Path
        ⎕CS ⊃ ↓ ⎕NL 9
        Res ← #.UT.run ¨ ⍎ Group
        ⎕CS ##
        ⎕EX 'TmpSpace'
        ⎕CS #.UT
        Res ← (⊃+/1=Res) (⊃+/0≠Res∧1≠Res) (⊃+/0=Res) 
        Group print_file_group_result Res
        Z ← Res
∇

∇ print_file_result Result
        ⎕ ← ''
        ⎕ ← Path 'unit tests'
        print_totals Result
∇

∇ Group print_group_result Result
        ⎕ ← ''
        ⎕ ← 'Group ',Group
        print_totals Result
∇

∇ Group print_file_group_result Result
        ⎕ ← ''
        ⎕ ← 'Group ',Group,' in ',Path
        print_totals Result
∇

∇ print_totals (Passed Exception Failed)
        ⎕ ← '⍋ ',(⍕ Passed),' PASSED'
        ⎕ ← '⋄ ',(⍕ Exception),' EXCEPTION'
        ⎕ ← '⍒ ',(⍕ Failed),' FAILED'
∇

:EndNameSpace