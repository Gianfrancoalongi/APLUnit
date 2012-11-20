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

∇ Z ← multi_line_array_failing_TEST;A;B
        A ← 2
        B ← 3
        Z ←  ((1 2) (2 3 4)) #.UT.eq ⍳ ¨ A B
∇

single_line_syntax_error_TEST ← { 1 #.UT.eq ⍳ }

∇ Z ← multi_line_index_error_TEST
        A ← 3
        B ← 4
        Z ← A #.UT.eq B ⌷ ⍳ A
∇

single_line_exception_2_TEST ← { #.UT.EN ← 2 ⋄ ⍳ }

single_line_exception_2_failing_TEST ← { #.UT.EN ← 3 ⋄ ⍳ }

∇ Z ← Tests 
        Z ← ⍬
        Z ,← 1 ≡ #.UT.run 'single_line_TEST'
        Z ,← 0 ≡ #.UT.run 'single_line_failing_TEST'
        Z ,← 1 ≡ #.UT.run 'single_line_array_TEST'
        Z ,← 0 ≡ #.UT.run 'single_line_array_failing_TEST'
        Z ,← 1 ≡ #.UT.run 'multi_line_scalar_TEST'
        Z ,← 0 ≡ #.UT.run 'multi_line_failing_scalar_TEST'
        Z ,← 1 ≡ #.UT.run 'multi_line_array_TEST'
        Z ,← 0 ≡ #.UT.run 'multi_line_array_failing_TEST'
        Z ,← (2 0 2) ≡ #.UT.run_file '/home/gianfranco/APL/UnitTestFrameWork/UTFile.dyalog'
        Z ,← 2 ≡ #.UT.run 'single_line_syntax_error_TEST'
        Z ,← 3 ≡ #.UT.run 'multi_line_index_error_TEST'
        Z ,← 1 ≡ #.UT.run 'single_line_exception_2_TEST'
        Z ,← 0 ≡ #.UT.run 'single_line_exception_2_failing_TEST'
∇

:EndNameSpace