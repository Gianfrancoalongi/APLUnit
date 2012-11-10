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
                ⎕ ← '  ',Res[1]               
                ⎕ ← 'Got'
                ⎕ ← '  ',Res[2]
                Z ← 0
        :Else
                Z ← Res
        :EndIf
∇

:EndNameSpace