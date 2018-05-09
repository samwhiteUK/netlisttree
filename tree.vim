"establish a list to hold every mudule, act as a file list
let s:moduleDict = {}


function! GetCurrentFileTree()

  "establish a list to hold the module and its submodules
  let b:topDict = {}

  "establish a dictionary to hold the modules and
  "their instance names
  let b:subDict = {}

  "read the file
  let file = readfile(expand("%:p")) " read the file

  for line in file

    "find modules inside current module, and their type
    let b:match = matchlist(line, '\s*\(\S*\) *: *entity *\(work\.\)\(.*\)')
    if (!empty(b:match))
      call extend(b:subDict, {b:match[1] : {b:match[3] : {}}})
    endif

    "find the top module
    let b:match = matchlist(line, '\s*entity\s*\(\S*\)\s*is.*')
    if (!empty(b:match))
      call extend(b:topDict, {b:match[1] : b:subDict})
      let moduleName = b:match[1]
    endif


  endfor
  silent! unlet s:moduleDict[moduleName]
  call extend(s:moduleDict, b:topDict)

endfunction

"this function recursively descends down the tree and
"replaces modules with their more in-dpeth definitions 
"if required
function! DescendTree(subModules, module)
  for instName in keys(a:subModules)
    let moduleName = keys(a:subModules[instName])[0]
    if (a:module == moduleName)
      if (a:subModules[instName][moduleName] == {})
        let a:subModules[instName][moduleName] = s:moduleDict[moduleName]
        let s:found = 1
      endif
    else 
      if (a:subModules[instName][moduleName] != {})
        call DescendTree(a:subModules[instName], a:module)
      endif
    endif
  endfor
endfunction

"this fnction loops through the discovered hierarchy and prints the 
"tree
function! PrintTree(tree, levelsDeep)
  for instName in keys(a:tree)
    let moduleName = keys(a:tree[instName])[0]
    echo "\r"
    for level in range(0,a:levelsDeep)
      echon "  "
    endfor
    echon instName . "  " . moduleName
    if (a:tree[instName][moduleName] != {} )
      call PrintTree(a:tree[instName][moduleName], a:levelsDeep + 1)
    endif
  endfor
endfunction


"this function loops over the files currently in moduleDict, and finds
"them in other modules' dictionaries, constructing the tree
function! CompileOverallTree()
  for topLevel in keys(s:moduleDict)
    let s:found = 0
    for module in keys(s:moduleDict)
      call DescendTree(s:moduleDict[module], topLevel)
    endfor
    if (s:found == 1)
      unlet s:moduleDict[topLevel]
    endif
  endfor

  "print the tree
  let topLevel = keys(s:moduleDict)[0]
  echo topLevel
  call PrintTree(s:moduleDict[topLevel], 0)


endfunction
      




" module to test = keys[0]
"
" if key == module to test
"   if values not empty 
"     go to next key
"   else
"     replace with the "top level" entry
"   end
" else 
"   if values empty
"     skip - it's bottom level
"   else 
"     descend - go through this funciton again, passing in the values to
"     iterate over
"   end
" end




