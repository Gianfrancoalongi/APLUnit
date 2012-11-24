:NameSpace UTFile

fromfile_single_line_TEST ← { 2 #.UT.eq 1 + 1 } 

fromfile_single_line_failing_scalar_TEST ← { 3 #.UT.eq 1 + 1 }

fromfile_single_line_array_TEST ← { (1,⍬) (1 2) (1 2 3) #.UT.eq ⍳¨⍳3 } 

fromfile_single_line_failing_array_TEST ← { 1 (1 2) (1 2 3) #.UT.eq ⍳¨⍳3 }

∇ fromfile_multi_line_exception_2_TEST;A
        A ← 3
        #.UT.EN ← 2
        A ⍳
∇

fromfile_single_line_exception_3_TEST ← { #.UT.EN ← 3 ⋄ 4 ⌷ ⍳ 3 }

fromfile_single_line_index_error_TEST ← { 4 ⌷ ⍳ 3 }

∇ multi_line_syntax_error_TEST;A
        A ← 1
        ⍳
∇ 

fromfile_single_line_expect_exception_failing_TEST ← { #.UT.EN ← 2 ⋄ 1 + 1 }

file_GROUP ← ('fromfile_single_line_TEST' 'fromfile_single_line_failing_scalar_TEST')

:EndNameSpace