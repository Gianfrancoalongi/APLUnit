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

∇ rank_error_TEST
        #.UT.exception ← 'RANK ERROR'
        1 ⊃ 1
∇

∇ failing_error_TEST
        #.UT.exception ← 'DOMAIN ERROR'
        1 ⊃ 1
∇

List ← 'passing_basic_TEST' 'crashing_TEST' 'failing_basic_TEST'

∇ Z ← Tests;UTres
        
        UTres ← #.UT.run 'passing_basic_TEST'
        Z ← (1 0 0) ≡ UTres.(Passed Crashed Failed)

        UTres ←  #.UT.run 'failing_basic_TEST'
        Z ,← (0 0 1) ≡ UTres.(Passed Crashed Failed)

        UTres ←  #.UT.run 'crashing_TEST'
        Z ,← (0 1 0) ≡ UTres.(Passed Crashed Failed)

        UTres ←  #.UT.run 'rank_error_TEST'
        Z ,← (1 0 0) ≡ UTres.(Passed Crashed Failed)
        
        UTres ←  #.UT.run 'failing_error_TEST'
        Z ,← (0 0 1) ≡ UTres.(Passed Crashed Failed)
        
        UTres ← #.UT.run List
        Z,← ((1 0 0) (0 1 0) (0 0 1)) ≡ { ⍵.(Passed Crashed Failed) } ¨ UTres
        
        UTres ← #.UT.run '/home/gianfranco/APL/UnitTestFrameWork/UTFile.dyalog'
        Z,← ((1 0 0) (0 1 0) (0 0 1)) ≡ { ⍵.(Passed Crashed Failed) } ¨ UTres
        
        Conf ← ⎕NEW #.UT.UTcover
        Conf.Cover ← '#.UTT.passing_basic_TEST' '#.UTT.rank_error_TEST'
        Conf.Pages ← '/home/gianfranco/APL/UnitTestFrameWork/Pages/'
        Conf #.UT.run 'passing_basic_TEST'

        Conf.Cover ← '#.UTT.passing_basic_TEST' '#.UTT.crashing_TEST' '#.UTT.failing_basic_TEST'
        Conf.Pages ← '/home/gianfranco/APL/UnitTestFrameWork/Pages/'
        Conf #.UT.run List

        Conf.Cover ← '#.UTFile.pick_elem_TEST' '#.UTFile.array_of_num_TEST' '#.UTFile.indexing_TEST'
        Conf.Pages ← '/home/gianfranco/APL/UnitTestFrameWork/Pages/'
        Conf #.UT.run '/home/gianfranco/APL/UnitTestFrameWork/UTFile.dyalog'
∇

:EndNameSpace