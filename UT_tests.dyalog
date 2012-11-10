:NameSpace UTT

single_line_TEST ← { 2 #.UT.eq 1 + 1 } 

single_line_failing_TEST ← { 2 #.UT.eq 1 }

single_line_array_TEST ← { (1 2 3) #.UT.eq ⍳ 3 }

single_line_array_failing_TEST ← { (1 2 3 4) #.UT.eq ⍳ 3 }

∇ Z ← Tests 
        Z ← ⍬
        Z ,← 1 ≡ #.UT.run ⎕OR 'single_line_TEST'
        Z ,← 0 ≡ #.UT.run ⎕OR 'single_line_failing_TEST'
        Z ,← 1 ≡ #.UT.run ⎕OR 'single_line_array_TEST'
        Z ,← 0 ≡ #.UT.run ⎕OR 'single_line_array_failing_TEST'
∇

:EndNameSpace