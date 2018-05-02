"establish a list to hold every mudule, act as a file list
let s:moduleList = []



function! GetCurrentFileTree()
 
  "establish a list to hold the module and its submodules
  let b:topList = []

  "establish a dictionary to hold the modules and
  "their instance names
  let b:subDict = {}

  "read the file
  let file = readfile(expand("%:p")) " read the file

  for line in file
    let s:match = matchlist(line, 'entity *\(\S*\) *is.*')
    if (!empty(s:match))
      " add if it's not already present
      if (get(s:moduleList, s:match[1], 'notfound') =~ 'notfound') 
        call add(s:moduleList, s:match[1])
      endif
      call add(b:topList, s:match[1])
    endif

    "find modules inside current module, and their type
    let s:match = matchlist(line, '\s*\(\S*\) *: *entity *\(work\.\)\(.*\)')
    if (!empty(s:match))
      "echo s:match
      call extend(b:subDict, {s:match[3] : s:match[1]})
    endif
  endfor
  echo b:subDict
  call add(b:topList, b:subDict)
  echo b:topList
  echo s:moduleList
endfunction
