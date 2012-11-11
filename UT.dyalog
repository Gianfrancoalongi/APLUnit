:NameSpace UT

∇ Z ← LHS eq RHS
        :If LHS ≡ RHS
                Z ← 1
        :Else
                Z ← LHS RHS
        :EndIf
∇

∇ Z ← run Function;Name;Res;Tmp
        Name ← ⎕FX Function
        Res ← execute_function Name
        :If 1 = ⍴⍴ Res
                ⎕ ← 'FAILED:',function_header Name 
                ⎕ ← 'Expected'
                ⎕ ← show_term ⊃Res[1]
                ⎕ ← 'Got'
                ⎕ ← show_term ⊃Res[2]
                Z ← 0
        :Else
                Z ← Res
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


:EndNameSpace