:NameSpace UTTests2_tests

∇ Z ← scalar_plus_TEST
  #.UT.expect ← 2
  Z ← 1 + 1
∇

∇ Z ← scalar_array_plus_TEST
  #.UT.expect ← 2 3 4
  Z ← 1 + ⍳ 3
∇

∇ Z ← array_array_plus_TEST
  #.UT.expect ← 2 4 6
  Z ← (⍳3) + ⍳ 3
∇

∇ Z ← scalar_matrix_plus_TEST
  #.UT.expect ← ↑ (2 3 4) (5 6 7) (8 9 10)
  Z ← 1 + 3 3 ⍴ ⍳ 9
∇

∇ Z ← matrix_matrix_plus_TEST
  #.UT.expect ← ↑ (2 4 6) (8 10 12) (14 16 18)
  Z ← (3 3 ⍴ ⍳ 9) + 3 3 ⍴ ⍳ 9
∇

:EndNameSpace