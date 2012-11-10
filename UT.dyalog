:NameSpace UT

∇ Z ← LHS eq RHS
        Z ← LHS ≡ RHS
∇

∇ Z ← run Function;Name
        Name ← ⎕FX Function
        Z ← ⍎ Name,' ⍬'
∇

:EndNameSpace