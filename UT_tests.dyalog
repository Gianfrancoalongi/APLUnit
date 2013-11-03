:NameSpace UTT

    ∇ Z←passing_basic_TEST
      #.UT.expect←1 2
      Z←1 2
    ∇

    ∇ Z←failing_basic_TEST
      #.UT.expect←1 2
      Z←1
    ∇

    ∇ Z←crashing_TEST
      #.UT.expect←4
      Z←5⊃⍳4
    ∇

    ∇ passing_rank_error_TEST
      #.UT.exception,←⊂'RANK ERROR'
      #.UT.exception,←⊂'passing_rank_error_TEST[5] 1⊃1'
      #.UT.exception,←⊂'                          ∧   '
      #.UT.exception←↑#.UT.exception
      1⊃1
    ∇

    ∇ failing_error_TEST
      #.UT.exception←'DOMAIN ERROR'
      1⊃1
    ∇

    ∇ Z←non_equality_TEST
      #.UT.nexpect←1 2 3
      Z←1 2 3⍳1
    ∇

    ∇ Z←failing_non_equality_TEST
      #.UT.nexpect←1
      Z←1 2 3⍳1
    ∇

      dfun_TEST←{
          #.UT.expect←1 2 3
          1 2 3
      }

    List ← 'passing_basic_TEST' 'crashing_TEST' 'failing_basic_TEST'
    
    ∇ Z←quad_IO_modified_TEST
      #.UT.expect←0 1 2
      ⎕IO←0
      Z←⍳3
    ∇

    ∇ Z←Tests;UTres
      Z←⍬
      UTres←#.UT.run'passing_basic_TEST'
      Z,←UTres≡⊂,(1 0 0)
     
      UTres←#.UT.run'failing_basic_TEST'
      Z,←UTres≡⊂,(0 0 1)
     
      UTres←#.UT.run'crashing_TEST'
      Z,←UTres≡⊂,(0 1 0)
     
      UTres←#.UT.run'passing_rank_error_TEST'
      Z,←UTres≡⊂,(1 0 0)
     
      UTres←#.UT.run'failing_error_TEST'
      Z,←UTres≡⊂,(0 0 1)
     
      UTres←#.UT.run'non_equality_TEST'
      Z,←UTres≡⊂,(1 0 0)
     
      UTres←#.UT.run'failing_non_equality_TEST'
      Z,←UTres≡⊂,(0 0 1)
     
      UTres←#.UT.run List
      Z,←((1 0 0)(0 1 0)(0 0 1))≡UTres
     
      UTres←#.UT.run'dfun_TEST'
      Z,←UTres≡⊂,(1 0 0)
     
      UTres←#.UT.run'./UTFile.dyalog'
      Z,←((1 0 0)(0 1 0)(0 0 1))≡UTres
     
      UTres←#.UT.run'./Empty_tests.dyalog'
      Z,←⍬≡UTres
     
      UTres←#.UT.run'./Pages/'
      Z,←⍬≡UTres
     
      UTres←#.UT.run'quad_IO_modified_TEST'
      Z,←UTres≡⊂,1 0 0
     
      Z,←'Test execution report'≡#.UT.determine_report_heading'some_TEST'
     
      Z,←'Test execution report for 3 tests'≡#.UT.determine_report_heading List
     
      Z,←'Test execution report for ./UTFile.dyalog'≡#.UT.determine_report_heading'./UTFile.dyalog'
     
      Z,←'Test execution report for ./Pages/'≡#.UT.determine_report_heading'./Pages/'
    ∇

:EndNameSpace

