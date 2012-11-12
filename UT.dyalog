:NameSpace UT

∇ Z ← LHS eq RHS
        Z ← 1
        :If LHS ≢ RHS
                Z ← LHS RHS
        :EndIf
∇

∇ Z ← run Function;Name;Res;Tmp
        Name ← ⎕FX Function
        Res ← execute_function Name
        Z ← Res
        :If 1 = ⍴⍴ Res
                Name display_expected_got Res
                Z ← 0
        :EndIf
        ⎕EX Name
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

∇ Z ← run_file Path;TmpSpace;Fns;Res
        'TmpSpace' ⎕NS ''
        'TmpSpace' ⎕NS '#.DISPLAY' '#.UT.is_test' '#.UT.get_namespace'
        ⎕CS 'TmpSpace'
        ⎕SE.SALT.Load Path
        ⎕CS get_namespace
        (⍕ ⎕THIS) ⎕NS '#.UT.is_test'
        (⍕ ⎕THIS) ⎕NS '#.UT.run' '#.UT.eq' '#.UT.execute_function'
        (⍕ ⎕THIS) ⎕NS '#.UT.display_expected_got' '#.UT.function_header' 
        (⍕ ⎕THIS) ⎕NS '#.UT.show_term' '#.DISPLAY'        
        Fns ← ↓ ⎕THIS.⎕NL 3
        Fns ← ( is_test ¨ Fns) / Fns
        Res ← run∘⎕OR ¨ Fns
        ⎕CS ##
        ⎕CS ##
        ⎕EX 'TmpSpace'
        Z ← (⊃+/1=Res) (⊃+/0=Res)
∇

∇ Z ← get_namespace
        Z ← ⊃ ↓ ⎕NL 9
∇

∇ Z ← is_test FunctionName;Index;Tmp
        Index ← FunctionName ⍳ ' '
        :If Index > ⍴ FunctionName
                Tmp ← FunctionName
        :Else
                Tmp ← FunctionName[⍳Index]
        :EndIf
        Z ← '_TEST' ≡ ¯5 ↑ Tmp
∇

:EndNameSpace