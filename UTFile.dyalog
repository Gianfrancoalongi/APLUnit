:NameSpace UTFile

∇ Z ← pick_elem_TEST
        #.UT.expect ← 3
        Z ← 2 ⊃ ⍳ 2
∇

∇ Z ← array_of_num_TEST
        #.UT.expect ← 1 2 3
        Z ← ⍳ 3
∇

∇ Z ← indexing_TEST
        #.UT.expect ← 4
        Z ← 5 ⊃ ⍳ 4
∇

:EndNameSpace