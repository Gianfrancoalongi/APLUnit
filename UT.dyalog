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
        Res ← ⍎ Name,' ⍬'
        :If 1 = ⍴⍴ Res
                ⎕ ← 'FAILED:',(,⎕CR Name)
                ⎕ ← 'Expected'
                ⎕ ← show_term ⊃Res[1]
                ⎕ ← 'Got'
                ⎕ ← show_term ⊃Res[2]
                Z ← 0
        :Else
                Z ← Res
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