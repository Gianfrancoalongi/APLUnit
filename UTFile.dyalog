:NameSpace UTFile

fromfile_single_line_TEST ← { 2 #.UT.eq 1 + 1 } 

fromfile_single_line_failing_scalar_TEST ← { 3 #.UT.eq 1 + 1 }

fromfile_single_line_array_TEST ← { (1,⍬) (1 2) (1 2 3) #.UT.eq ⍳¨⍳3 } 

fromfile_single_line_failing_array_TEST ← { 1 (1 2) (1 2 3) #.UT.eq ⍳¨⍳3 }


:EndNameSpace