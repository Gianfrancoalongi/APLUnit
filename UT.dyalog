:NameSpace UT

EN ← ⍬

∇ Z ← expecting_an_exception
        Z ← #.UT.EN ≢ ⍬
∇
        
∇ Z ← failure_due_to_no_exception Function
        Function display_expected_got #.UT.EN ⍬
        #.UT.EN ← ⍬
        Z ← 0
∇

∇ Z ← test_failure Res
        Z ← 1 = ⍴⍴ Res
∇

∇ Z ← Function failure_test_failed Res
        Function display_expected_got Res
        Z ← 0
∇

∇ Z ← exception_number_does_not_match_expected
        Z ← #.UT.EN ≢ ⎕EN
∇

∇ Z ← failure_exception_failed Function
        Function display_expected_got #.UT.EN ⎕EN
        Z ← 0
∇

∇ Z ← Function check_success_or_failure Res
        :If expecting_an_exception
                Z ← failure_due_to_no_exception Function
        :Else
                :If test_failure Res
                        Z ← Function failure_test_failed Res
                :Else
                        Z ← Res
                :EndIf
        :EndIf
∇

∇ Z ← run Function;Res;Tmp
        Tmp ← 1 ⊃ ⎕RSI
        Tmp ← (⍕ ⎕THIS) ⎕NS ((⍕ Tmp),'.',Function)
        :Trap 0                
                Res ← execute_function Function
                Z ← Function check_success_or_failure Res
        :Else
                :If expecting_an_exception
                        :If exception_number_does_not_match_expected
                                Z ← failure_exception_failed Function
                        :Else
                                Z ← 1
                        :EndIf
                        #.UT.EN ← ⍬
                :Else
                        display_exception Function
                        Z ← ⎕EN
                :EndIf
        :EndTrap
        ⎕EX Function
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

∇ Z ← LHS eq RHS
        Z ← 1
        :If LHS ≢ RHS
                Z ← LHS RHS
        :EndIf
∇

∇ Z ← execute_function Name;R;C
        (R C) ← ⍴ ⎕CR Name
        :If R > 1 
                Z ← ⍎ Name
        :Else
                Z ← ⍎ Name,' ⍬'
        :EndIf
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
        ⎕ ← ' EM:',⎕EM ⎕EN
∇

∇ print_file_result Result
        (Path,' unit tests') print_totals Result
∇

∇ Group print_group_result Result
        ('Group ',Group) print_totals Result
∇

∇ Group print_file_group_result Result
        ('Group ',Group,' in ',Path)  print_totals Result
∇

∇ Header print_totals (Passed Exception Failed)
        ⎕ ← ' '
        ⎕ ← Header
        ⎕ ← '⍋ ',(⍕ Passed),' PASSED'
        ⎕ ← '⋄ ',(⍕ Exception),' EXCEPTION'
        ⎕ ← '⍒ ',(⍕ Failed),' FAILED'
∇

:EndNameSpace