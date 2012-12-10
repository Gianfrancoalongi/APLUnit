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

∇ multi_line_exception_3_TEST
        #.UT.EN ← 3
        4 ⌷ ⍳ 3
∇

∇ multi_line_exception_3_failing_TEST
        #.UT.EN ← 3
        4 ⌷ ⍳
∇

no_exception_single_line_exception_TEST ← { #.UT.EN ← 2 ⋄ 1 + 2 } 

test_GROUP ← ('single_line_TEST' 'single_line_failing_TEST' 'single_line_syntax_error_TEST')

∇ Z ← Tests 
        Z ← ⍬
        ⎕ ← '================== Starting Unit Test Execution ================='
        ⎕ ← '--------------------- Singe line tests'
        Z ,← 1 ≡ ⊃ #.UT.run 'single_line_TEST'
        Z ,← 1 ≡ ⊃ #.UT.run 'single_line_array_TEST'
        Z ,← 1 ≡ ⊃ #.UT.run 'single_line_exception_2_TEST'
        ⎕ ← '--------------------- Single line failing tests'
        Z ,← 0 ≡ ⊃ #.UT.run 'single_line_failing_TEST'
        Z ,← 0 ≡ ⊃ #.UT.run 'single_line_array_failing_TEST'
        Z ,← 2 ≡ ⊃ #.UT.run 'single_line_syntax_error_TEST'
        Z ,← 0 ≡ ⊃ #.UT.run 'single_line_exception_2_failing_TEST'
        ⎕ ← '-------------------- Multi line tests'
        Z ,← 1 ≡ ⊃ #.UT.run 'multi_line_scalar_TEST'
        Z ,← 1 ≡ ⊃ #.UT.run 'multi_line_array_TEST'
        Z ,← 1 ≡ ⊃ #.UT.run 'multi_line_exception_3_TEST'
        ⎕ ← '-------------------- Multi line failing tests'
        Z ,← 0 ≡ ⊃ #.UT.run 'multi_line_failing_scalar_TEST'
        Z ,← 0 ≡ ⊃ #.UT.run 'multi_line_array_failing_TEST'
        Z ,← 3 ≡ ⊃ #.UT.run 'multi_line_index_error_TEST'
        Z ,← 0 ≡ ⊃ #.UT.run 'multi_line_exception_3_failing_TEST'
        Z ,← 0 ≡ ⊃ #.UT.run 'no_exception_single_line_exception_TEST'
        ⎕ ← '-------------------- Execution from file'
        Z ,← (4 2 3) ≡ 3 ↑ #.UT.run_file '/home/gianfranco/APL/UnitTestFrameWork/UTFile.dyalog'
        ⎕ ← '-------------------- Execution of GROUP'
        Z ,← (1 1 1) ≡ 3 ↑ #.UT.run_group 'test_GROUP'
        ⎕ ← '-------------------- Execution of GROUP from File'
        Z ,← (1 0 1) ≡ 3 ↑ 'file_GROUP' #.UT.run_group_file '/home/gianfranco/APL/UnitTestFrameWork/UTFile.dyalog'
        ⎕ ← '================= Finished Unit Test Execution =================='
∇

:EndNameSpace