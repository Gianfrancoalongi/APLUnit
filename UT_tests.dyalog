:NameSpace UTT

single_line_TEST ← { 2 #.UT.eq 1 + 1 } 

single_line_failing_TEST ← { 2 #.UT.eq 1 }

∇ Z ← Tests 
        Z ← ⍬
        Z ,← 1 ≡ #.UT.run ⎕OR 'single_line_TEST'
        Z ,← 0 ≡ #.UT.run ⎕OR 'single_line_failing_TEST'
∇

:EndNameSpace