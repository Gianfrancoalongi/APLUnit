:NameSpace UTT

∇ Z ← passing_basic_TEST
        #.UT.expect ← ⍳ 2
        Z ← 1 2
∇

∇ Z ← failing_basic_TEST
        #.UT.expect ← ⍳ 2
        Z ← ⊂ 1
∇

∇ Z ← crashing_TEST
        #.UT.expect ← 4
        Z ← 5 ⊃ ⍳ 4
∇

List ← 'passing_basic_TEST' 'crashing_TEST' 'failing_basic_TEST'

∇ Tests 
        #.UT.run 'passing_basic_TEST'
        #.UT.run 'failing_basic_TEST'
        #.UT.run_tests List
        #.UT.run_file '/home/gianfranco/APL/UnitTestFrameWork/UTFile.dyalog'
∇

:EndNameSpace