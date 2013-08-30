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
  #.UT.exception,← ⊂'RANK ERROR'
  #.UT.exception,← ⊂'rank_error_TEST[5] 1⊃1'
  #.UT.exception,← ⊂'                  ∧   '
  #.UT.exception ← ↑ #.UT.exception
  1 ⊃ 1
∇

∇ failing_error_TEST
        #.UT.exception ← 'DOMAIN ERROR'
        1 ⊃ 1
∇

∇ Z ← non_equality_TEST 
  Z ← 1 2 3 ⍳ 1
  #.UT.nexpect ← 1 2 3
∇

∇ Z ← failing_non_equality_TEST
  Z ← 1 2 3 ⍳ 1
  #.UT.nexpect ← 1
∇

dfun_TEST ← {
        #.UT.expect ← 1 2 3
        1 2 3
}

List ← 'passing_basic_TEST' 'crashing_TEST' 'failing_basic_TEST'

∇ Z ← Tests;UTres
  Z ← ⍬
  UTres ← #.UT.run 'passing_basic_TEST'
  Z ,← (1 0 0) ≡ UTres
  
  UTres ←  #.UT.run 'failing_basic_TEST'
  Z ,← (0 0 1) ≡ UTres
  
  UTres ←  #.UT.run 'crashing_TEST'
  Z ,← (0 1 0) ≡ UTres
  
  UTres ←  #.UT.run 'rank_error_TEST'
  Z ,← (1 0 0) ≡ UTres
  
  UTres ←  #.UT.run 'failing_error_TEST'
  Z ,← (0 0 1) ≡ UTres

  UTres ← #.UT.run 'non_equality_TEST'
  Z ,← (1 0 0) ≡ UTres

  UTres ← #.UT.run 'failing_non_equality_TEST'
  Z ,← (0 0 1) ≡ UTres

  UTres ← #.UT.run List
  Z,← ((1 0 0) (0 1 0) (0 0 1)) ≡ UTres

  UTres ← #.UT.run 'dfun_TEST'
  Z,← (1 0 0) ≡ UTres
  
  UTres ← #.UT.run '/home/gianfranco/APL/UnitTestFrameWork/UTFile.dyalog'
  Z,← ((1 0 0) (0 1 0) (0 0 1)) ≡ UTres

  Conf ← ⍬
  Conf,← ⊂('cover_target' 'abba' 'cebba')
  Conf,← ⊂('cover_out' 'debba')
  Z,← ('abba' 'cebba') ≡ 'cover_target' #.UT.in Conf

  Conf ← ⍬
  Conf,← ⊂('cover_target' 'abba' 'cebba')
  Conf,← ⊂('cover_out' 'debba')
  Z,← (⍬,⊂'debba') ≡ 'cover_out' #.UT.in Conf

  Conf ← ⍬
  Conf,← ⊂('cover_target' 'abba' 'cebba')
  Conf,← ⊂('cover_out' 'debba')
  Z,← 1 ≡ Conf #.UT.has 'cover_out'
  
  Conf ← ⍬
  Conf,← ⊂('cover_target' ('#.UTT.passing_basic_TEST' '#.UTT.rank_error_TEST'))
  Conf,← ⊂('cover_out' '/home/gianfranco/APL/UnitTestFrameWork/Pages/')
  UTres ← Conf #.UT.run 'passing_basic_TEST'
  Z ,← (1 0 0) ≡ UTres
  
  Conf ← ⍬
  Conf,← ⊂('cover_target' ('#.UTT.passing_basic_TEST' '#.UTT.crashing_TEST' '#.UTT.failing_basic_TEST'))
  Conf,← ⊂('cover_out' '/home/gianfranco/APL/UnitTestFrameWork/Pages/')
  UTres ← Conf #.UT.run List
  Z,← ((1 0 0) (0 1 0) (0 0 1)) ≡ UTres

  Conf ← ⍬
  Conf,← ⊂('cover_target' ('#.UTFile.pick_elem_TEST' '#.UTFile.array_of_num_TEST' '#.UTFile.indexing_TEST'))
  Conf,← ⊂('cover_out' '/home/gianfranco/APL/UnitTestFrameWork/Pages/')
  UTres ←  Conf #.UT.run '/home/gianfranco/APL/UnitTestFrameWork/UTFile.dyalog'
  Z,← ((1 0 0) (0 1 0) (0 0 1)) ≡  UTres

  Conf ← ⍬
  Conf,← ⊂('cover_target' (⊂'#.Demo'))
  Conf,← ⊂('cover_out' '/home/gianfranco/APL/UnitTestFrameWork/Pages/')
  UTres ← Conf #.UT.run './Demo_tests.dyalog'
  Z,← ((1 0 0) (1 0 0) (1 0 0) (1 0 0) (1 0 0) (1 0 0)) ≡ UTres
∇

:EndNameSpace