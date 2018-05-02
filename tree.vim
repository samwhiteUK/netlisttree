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
    let b:match = matchlist(line, 'entity *\(\S*\) *is.*')
    if (!empty(b:match))
      " add if it's not already present
      if (index(s:moduleList, b:match[1]) == -1)
        call add(s:moduleList, b:match[1])
      endif
      call add(b:topList, b:match[1])
    endif

    "find modules inside current module, and their type
    let b:match = matchlist(line, '\s*\(\S*\) *: *entity *\(work\.\)\(.*\)')
    if (!empty(b:match))
      call extend(b:subDict, {b:match[1] : b:match[3]})
    endif
  endfor
  call add(b:topList, b:subDict)
  echo b:topList
  echo s:moduleList
endfunction
