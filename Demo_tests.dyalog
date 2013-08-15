:NameSpace Demo_tests

∇ Z ← count_zero_comments_from_no_input_TEST
  #.UT.expect ← 0
  Z ← #.Demo.count_comments ⍬
∇

∇ Z ← count_zero_comments_from_single_normal_line_TEST
  #.UT.expect ← 0
  Z ← #.Demo.count_comments 'int a;'
∇

∇ Z ← count_one_comment_from_single_line_TEST
  #.UT.expect ← 1
  Z ← #.Demo.count_comments '//this is a comment'
∇

∇ Z ← count_one_comment_which_has_leading_whitespace_TEST
  #.UT.expect ← 1
  Z ← #.Demo.count_comments ' //this is a comment'
∇

∇ Z ← count_no_comments_for_a_blank_line_TEST
  #.UT.expect ← 0
  Z ← #.Demo.count_comments '   '
∇

∇ Z ← count_multiple_comments_amongst_lines_TEST
  #.UT.expect ← 2
  Z ← #.Demo.count_comments '//first comment'  '//second comment'
∇

:EndNameSpace 