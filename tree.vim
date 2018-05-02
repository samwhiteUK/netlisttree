function! Tree()
  :g/\s*entity *\(.*\) *is.*/y t
  :vnew
  :put t
  :norm qtq
  :norm <C-w><C-w>
  :g/\s*\(\S*\) *: *entity.*/y T
  :norm <C-w><C-w>
  :put! t
  :%s//\1/g
  :g/^$/d
endfunction
