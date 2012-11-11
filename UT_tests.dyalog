:NameSpace UTT

single_line_TEST ← { 2 #.UT.eq 1 + 1 } 

single_line_failing_TEST ← { 2 #.UT.eq 1 }

single_line_array_TEST ← { (1 2 3) #.UT.eq ⍳ 3 }

single_line_array_failing_TEST ← { (1 2 3 4) #.UT.eq ⍳ 3 }

∇ Z ← multi_line_scalar_TEST;A;B
        A ← 1
        B ← 2
        Z ← 3 #.UT.eq (A + B)
∇

∇ Z ← multi_line_failing_scalar_TEST;A;B
        A ← 1
        B ← 2
        Z ← 3 #.UT.eq (A + B + B)
∇

∇ Z ← multi_line_array_TEST;A;B
        A ← 2
        B ← 3
        Z ←  ((1 2) (1 2 3)) #.UT.eq ⍳ ¨ A B
∇

∇ Z ← Tests 
        Z ← ⍬
        Z ,← 1 ≡ #.UT.run ⎕OR 'single_line_TEST'
        Z ,← 0 ≡ #.UT.run ⎕OR 'single_line_failing_TEST'
        Z ,← 1 ≡ #.UT.run ⎕OR 'single_line_array_TEST'
        Z ,← 0 ≡ #.UT.run ⎕OR 'single_line_array_failing_TEST'
        Z ,← 1 ≡ #.UT.run ⎕OR 'multi_line_scalar_TEST'
        Z ,← 0 ≡ #.UT.run ⎕OR 'multi_line_failing_scalar_TEST'
        Z ,← 1 ≡ #.UT.run ⎕OR 'multi_line_array_TEST'
∇

:EndNameSpace