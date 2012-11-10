:NameSpace UTT

single_line_TEST ← { 2 #.UT.eq 1 + 1 } 


∇ Z ← Tests 
        Z ← ⍬
        Z ,← #.UT.run ⎕OR 'single_line_TEST'
∇

:EndNameSpace