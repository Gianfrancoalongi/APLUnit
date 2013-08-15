:NameSpace Demo

∇ Z ← count_comments input
  :if input≡⍬
          Z ← 0
  :elseif 1≡≡input
          Z ← check_if_line_is_comment input
  :else
          Z ← +/count_comments ¨ input
  :endif
∇

∇ Z ← check_if_line_is_comment input
  input ← drop_leading_whitespace input
  :if ''≡input
          Z ← 0
  :else
          Z ← is_comment input 
  :endif  
∇

∇ Z ← drop_leading_whitespace input
  Z ← (~∧\' '=input)/input
∇

is_comment ← {'//'≡2↑⍵} 

:EndNameSpace 