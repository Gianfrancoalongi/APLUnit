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


:EndNameSpace