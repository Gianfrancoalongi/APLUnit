:NameSpace UTT

∇ Z ← passing_basic_TEST
        #.UT.expect ← ⍳ 2
        Z ← 1 2
∇

∇ Z ← failing_basic_TEST
        #.UT.expect ← ⍳ 2
        Z ← ⊂ 1
∇

∇ Tests 
        #.UT.run 'passing_basic_TEST'
        #.UT.run 'failing_basic_TEST'
∇

:EndNameSpace